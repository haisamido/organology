import psycopg

# Connect to an existing database
with psycopg.connect(
   dbname   = 'organology', 
   user     = 'postgres', 
   password = 'postgres', 
   host     = 'organology-database', 
   port     = '5432') as dbconnection:

    with dbconnection.cursor() as cursor:
      cursor.execute("select version()")
      dbversion = cursor.fetchone()
      print("Connection established to: ", dbversion)
