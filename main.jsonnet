local secrets = import "secrets.libsonnet";
{
    terraform: {
      required_providers:{
         postgresql: {
            source: "cyrilgdn/postgresql",
            version: "1.15.0"
         },
      }
   },
    provider: {
        "postgresql": {
          host            :"127.0.0.1",
          port            : 5432,
          database        :"postgres",
          username        : secrets.postgresql.auth.username,
          password        :secrets.postgresql.auth.password,
          sslmode         :"disable",
          connect_timeout :15
        }
    },
    resource: {
        postgresql_role:{
            app_www:{
                name: "app_www"
            },
            app_db:{
                name: "app_db"
            },
            app_releng:{
                name: "app_releng"
            }
        },
        postgresql_database: {
            my_db: {
                  name              :"my_db",
                  allow_connections :true
             }
         },
         postgresql_schema: {
             my_schema:{
                name: "my_schema",
                owner: "postgres",
                policy: [{
                   usage: true,
                   role: "${postgresql_role.app_www.name}"
               },{
                   create: true,
                   usage: true,
                   role: "${postgresql_role.app_releng.name}"
                 },{
                   create_with_grant: true,
                   usage_with_grant: true,
                   role: "${postgresql_role.app_db.name}"
                 }
                ],
              },

//              ]
         }
    }
}