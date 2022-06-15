apiVersion: batch/v1
kind: CronJob
metadata:
  name: sftp-stress-service-${label}
  namespace: ${namespace}
spec:
  schedule: "${schedule}"
  jobTemplate:
    spec:
      template:
        metadata:
          labels:
            aadpodidbinding: ${namespace}-pod-identity
        spec:
          restartPolicy: Never
          containers:
            - name: sftp-stress-${label}
              image: alpine:3
              command:
                - /bin/sh
                - -c
                - |
                  apk add openssh && \
                    sftp \
                      -oPasswordAuthentication=no \
                      -oPubkeyAcceptedKeyTypes=+ssh-rsa \
                      -oStrictHostKeyChecking=no \
                      -i /mnt/keys/..data/${username} \
                      ${destination} << EOF
                        put /mnt/azure/${filename}.tar
                        get ${filename}.tar
                        quit
                      EOF && \
                    sftp \
                      -oPasswordAuthentication=no \
                      -oPubkeyAcceptedKeyTypes=+ssh-rsa \
                      -oStrictHostKeyChecking=no \
                      -i /mnt/keys/..data/${username} \
                      ${destination} << EOF
                        get ${filename}.tar
                        del ${filename}.tar
                        quit
                      EOF && \
                    tar -xf ${filename}.tar && \
                    cd $(tar -tf ${filename}.tar | grep -m3 /$ | tail -1) && \
                    sha256sum -c $checksum
              resources:
                requests:
                  memory: 16Mi
                  cpu: 50m
                limits:
                  memory: 32Mi
                  cpu: 100m
              volumeMounts:
                - name: stress-files
                  mountPath: /mnt/azure
                - name: stress-keys
                  mountPath: /mnt/keys
          volumes:
            - name: stress-files
              csi:
                driver: file.csi.azure.com
                readOnly: true
                volumeAttributes:
                  secretName: sftp-stress-volume
                  shareName: stress-files
            - name: stress-keys
              secret:
                secretName: sftp-stress-keys
                defaultMode: 256
