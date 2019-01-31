# Remember to start HBase inside Ambari
# you also need to ssh into the machine and start the server as root
# su root
# /usr/hdp/current/hbase-master/bin/hbase-daemon.sh start rest -p <port> --infoport <infoport> 
# hbase rest start -p <port> --infoport <infoport>
# Remember to open port 8000
from starbase import Connection

c = Connection("127.0.0.1", "8000")

ratings = c.table('ratings')

if (ratings.exists()):
    print("Dropping existing ratings table\n")
    ratings.drop()

ratings.create('rating')

print("Parsing the ml-100k ratings data...\n")
ratingFile = open("./ml-100k/u.data", "r")

batch = ratings.batch()
print(batch)

for line in ratingFile:
    (userID, movieID, rating, timestamp) = line.split()
    batch.update(userID, {'rating': {movieID: rating}})

ratingFile.close()

print ("Committing ratings data to HBase via REST service\n")
batch.commit(finalize=True)

print ("Get back ratings for some users...\n")
print ("Ratings for user ID 1:\n")
print (ratings.fetch("1"))
print ("Ratings for user ID 33:\n")
print (ratings.fetch("33"))

ratings.drop()
