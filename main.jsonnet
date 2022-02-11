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
          host            :"172.18.8.101",
          port            : 30002,
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
              name: "my_schema",
              owner: "postgres",
              policy: {
                app_www: {
                  usage: true,
                  role: "app_www"
                }
              }
//                {
//                    usage: true,
//                    role: "${postgresql_role.app_www.name}"
//                },{
//                    usage: true,
//                    role: "${postgresql_role.app_www.name}"
//                },{
//                    create: true,
//                    usage: true,
//                    role: "${postgresql_role.app_releng.name}"
//                  },{
//                    create_with_grant: true,
//                    usage_with_grant: true,
//                    role: "${postgresql_role.app_dba.name}"
//                  }
//              ]
         }
    }
}