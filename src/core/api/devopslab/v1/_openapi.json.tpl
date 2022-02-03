{
  "openapi": "3.0.3",
  "info": {
    "title": "User Registry Management",
    "description": "User Registry Management",
    "version": "${version}",
    "contact": {
      "name": "API Support",
      "url": "http://www.example.com/support",
      "email": "support@example.com"
    },
    "termsOfService": "http://swagger.io/terms/",
    "x-api-id": "an x-api-id",
    "x-summary": "an x-summary"
  },
  "servers": [
    {
      "url": "https://${host}/pdnd-interop-uservice-user-registry-management/${version}",
      "description": "User registry service containing PII information"
    }
  ],
  "tags": [
    {
      "name": "user",
      "description": "Users",
      "externalDocs": {
        "description": "Find out more",
        "url": "http://swagger.io"
      }
    },
    {
      "name": "health",
      "description": "Verify service status",
      "externalDocs": {
        "description": "Find out more",
        "url": "http://swagger.io"
      }
    }
  ],
  "paths": {
    "/users": {
      "post": {
        "tags": [
          "user"
        ],
        "summary": "Create a new user",
        "operationId": "createUser",
        "requestBody": {
          "description": "User object that needs to be created",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/UserSeed"
              }
            }
          },
          "required": true
        },
        "responses": {
          "201": {
            "description": "User created",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/User"
                }
              }
            }
          },
          "400": {
            "description": "Invalid input",
            "content": {
              "application/problem+json": {
                "schema": {
                  "$ref": "#/components/schemas/Problem"
                }
              }
            }
          }
        }
      }
    },
    "/users/id/{id}": {
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "description": "The internal ID of the User",
          "required": true,
          "schema": {
            "type": "string",
            "format": "uuid"
          }
        }
      ],
      "get": {
        "tags": [
          "user"
        ],
        "summary": "Retrieve the user for the given internal id",
        "description": "Return the user",
        "operationId": "getUserById",
        "responses": {
          "200": {
            "description": "User",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/User"
                }
              }
            }
          },
          "404": {
            "description": "User not found",
            "content": {
              "application/problem+json": {
                "schema": {
                  "$ref": "#/components/schemas/Problem"
                }
              }
            }
          }
        }
      }
    },
    "/users/external-id": {
      "post": {
        "tags": [
          "user"
        ],
        "summary": "Retrieve the user for the given external ID",
        "description": "Return the user ID",
        "operationId": "getUserByExternalId",
        "requestBody": {
          "description": "Person External ID to retrieve the User",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/EmbeddedExternalId"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "User",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/User"
                }
              }
            }
          },
          "404": {
            "description": "User not found",
            "content": {
              "application/problem+json": {
                "schema": {
                  "$ref": "#/components/schemas/Problem"
                }
              }
            }
          }
        }
      }
    },
    "/users/update": {
      "post": {
        "tags": [
          "user"
        ],
        "summary": "Update an existing user",
        "operationId": "updateUser",
        "requestBody": {
          "description": "User object that needs to be updated",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/UserSeed"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "User updated",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/User"
                }
              }
            }
          },
          "400": {
            "description": "Invalid input",
            "content": {
              "application/problem+json": {
                "schema": {
                  "$ref": "#/components/schemas/Problem"
                }
              }
            }
          }
        }
      }
    },
    "/status": {
      "get": {
        "tags": [
          "health"
        ],
        "summary": "Health status endpoint",
        "description": "Return ok",
        "operationId": "getStatus",
        "responses": {
          "200": {
            "description": "successful operation",
            "content": {
              "application/problem+json": {
                "schema": {
                  "$ref": "#/components/schemas/Problem"
                }
              }
            }
          }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "User": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string",
            "format": "uuid"
          },
          "externalId": {
            "type": "string"
          },
          "name": {
            "type": "string"
          },
          "surname": {
            "type": "string"
          },
          "certification": {
            "$ref": "#/components/schemas/Certification"
          },
          "extras": {
            "$ref": "#/components/schemas/UserExtras"
          }
        },
        "required": [
          "id",
          "name",
          "surname",
          "externalId",
          "certification",
          "extras"
        ]
      },
      "UserSeed": {
        "type": "object",
        "properties": {
          "externalId": {
            "type": "string"
          },
          "name": {
            "type": "string"
          },
          "surname": {
            "type": "string"
          },
          "certification": {
            "$ref": "#/components/schemas/Certification"
          },
          "extras": {
            "$ref": "#/components/schemas/UserExtras"
          }
        },
        "required": [
          "externalId",
          "name",
          "surname",
          "certification",
          "extras"
        ]
      },
      "Certification": {
        "type": "string",
        "description": "Certified source of information",
        "enum": [
          "NONE",
          "SPID"
        ]
      },
      "EmbeddedExternalId": {
        "type": "object",
        "properties": {
          "externalId": {
            "type": "string",
            "description": "The external ID (e.g. tax code) of the User"
          }
        },
        "required": [
          "externalId"
        ]
      },
      "UserExtras": {
        "type": "object",
        "properties": {
          "email": {
            "type": "string"
          },
          "birthDate": {
            "type": "string",
            "format": "date"
          }
        }
      },
      "Problem": {
        "properties": {
          "detail": {
            "description": "A human readable explanation specific to this occurrence of the problem.",
            "example": "Request took too long to complete.",
            "type": "string"
          },
          "status": {
            "description": "The HTTP status code generated by the origin server for this occurrence of the problem.",
            "example": 503,
            "exclusiveMaximum": true,
            "format": "int32",
            "maximum": 600,
            "minimum": 100,
            "type": "integer"
          },
          "title": {
            "description": "A short, summary of the problem type. Written in english and readable",
            "example": "Service Unavailable",
            "type": "string"
          }
        },
        "additionalProperties": false,
        "required": [
          "status",
          "title"
        ]
      }
    }
  }
}
