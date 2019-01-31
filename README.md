# The Ultimate Hands-On Hadoop - Tame your Big Data!

* Install Horton works stack (that contains Hadoop and other tools)
    * `cd HDP_3.0.1_docker-deploy-scripts_18120587fc7fb/`
    * `sh docker-deploy-hdp30.sh`
        * In case you experience a port issue like: 
            * `C:\Program Files\Docker\Docker\Resources\bin\docker.exe: Error response from daemon: driver failed programming external connectivity on endpoint sandbox-proxy (2e13894570ec36a982eb51009448c128854214a8286088e01da9f7881b6dd100): Error starting userland proxy: Bind for 0.0.0.0:50070: unexpected error Permission denied.`
            * You can fix it by setting different ports inside the `sandbox/proxy/proxy-deploy.sh` file, this is dynamically generated when we run `sh docker-deploy-hdp30.sh`  
                * Edit file `sandbox/proxy/proxy-deploy.sh`
                * Modify conflicting port (first in keypair). For example, `6001:6001` to `16001:6001`
                * Save/Exit the File
                * Run bash script: bash `sandbox/proxy/proxy-deploy.sh`
                * Repeat steps for continued port conflicts
    * Verify sandbox was deployed successfully by issuing the command: `docker ps`
        * You should see two containers, one for the `nginx` proxy and another one for the actual tools
            * ![setup](images/setup-hortonworks.PNG)
    * In order to stop the HDP sandbox just run:
        * `docker stop sandbox-hdp`
        * `docker stop sandbox-proxy`
        * To remove the containers you just need to do:
            * `docker rm sandbox-hdp`
            * `docker rm sandbox-proxy`
        * To remove the image just run:
            * `docker rmi hortonworks/sandbox-hdp:3.0.1`
            * `docker rmi hortonworks/sandbox-proxy:1.0`
    * To start just run:
        * `docker start sandbox-hdp`
        * `docker start sandbox-proxy`
    * In case you want a CNAME, you can add this line to your hosts file:
        * `127.0.0.1 sandbox-hdp.hortonworks.com `
            * `C:\Windows\System32\drivers\etc\hosts` on Windows
            * `/etc/hosts` on a MacOSX
    * Now we are able to open `Ambari` by accessing:
        * `http://sandbox-hdp.hortonworks.com:1080/splash.html`
        * `sandbox-hdp.hortonworks.com:8080` or `127.0.0.1:8080`
    * The default `Ambari` user is:
        * username: `maria_dev`, password: `maria_dev`

* First, we will import both `ml-100k` `u.data` and `u.item` using `Hive`
    * You can find `Hive` by clicking the menu icon on the top right corner
    * After importing the data, we are able to run SQL queries even though the data is saved in a Hadoop cluster (HDFS) 
        * `SELECT movie_id, count(movie_id) as ratingCount FROM ratings GROUP BY movie_id ORDER BY ratingCount DESC`
        * `SELECT name FROM movie_names WHERE movie_id = 50;`

## Hadoop Overview and History

* "An open source software platform for distributed storage and distributed processing of very large data sets on computer clusters built from commodity hardware" - Hortonworks

* Google published papers about GFS (Google File System) and MapReduce - 2003-2004

* Yahoo! was building "Nutch", and open source web search engine at the same time
    * Doug Cutting and Tom White started putting Hadoop together in 2006
    * Hadoop was the name of one of the toys of Doug Cutting child. Yellow stuffed elephant 

* Data is too darm big - terabytes per day
* Vertical scaling doesn't cut it 
    * In a database world horizontal-scaling is often based on the partitioning of the data i.e. each node contains only part of the data, in vertical-scaling the data resides on a single node and scaling is done through multi-core i.e. spreading the load between the CPU and RAM resources of that machine.
        * With horizontal-scaling it is often easier to scale dynamically by adding more machines into the existing pool - Vertical-scaling is often limited to the capacity of a single machine, scaling beyond that capacity often involves downtime and comes with an upper limit.
    * Vertical scaling means more memory and cpu in the existent machines
    * Horizontal scaling means more machines
    * Vertical scaling issues:
        * Disk seek times
        * Hardware failures 
        * Processing times
    * ![scaling](./images/scaling.PNG) 
* It is not just for batch processing anymore

## Hadoop Ecosystem

* World of Hadoop
    * Core Hadoop Ecosystem
        * ![core](./images/hadoop-core.PNG)
        * HDFS: Hadoop Distributed File System
            * Makes all the hard drives looks like a single one
            * Also, it is responsible for data redundancy (recover)
        * YARN: Yet Another Resource Negotiator
            * Sits on top of HDFS
            * Manages the resources in your computer cluster
                * What gets to run when
                * Which nodes are available
        * Mesos
            * An alternative to YARN
            * Also a resource negotiator 
            * Solve the same problem in different ways
        * MapReduce
            * Sits on top of YARN
            * Process you data across an entire cluster
            * It consists of Mappers and Reducers
                * Mappers: transform your data in parallel 
                * Reducer: aggregate data together 
        * Spark
            * Sitting at the same level of MapReduce
            * Works with YARN or Mesos
            * To run queries on your data
                * Also handles SQL queries, ML tasks, streaming data
            * Write your spark scripts using Java, Scala or Python
                * Scala being preferred 
        * Tez
            * Similar to Spark (direct acyclic graph)
            * Tez is used in conjunction with Hive to accelerate it
        * HBase
            * Exposing the data on your cluster to transaction platforms 
            * NoSQL database (large transaction rates)
            * Fast way of exposing those resources to other systems
        * Apache Storm
            * Process streaming data in real time (log data is an example)
                * Sensor data
            * Spark streaming solves the same problem, but in a different way
            * Update your ML models, or transform data in a database in real time (no batch processing)
        * Pig
            * Sits on top of MapReduce
            * A high level programming API that
            * Allows us to write simple scripts that looks a lot like SQL in some cases
                * Chain queries together without coding Java or Python
            * This script will be transformed in something that runs on top of MapReduce 
        * Hive
            * Sits on top of MapReduce
            * Makes this HDFS files system looks like a SQL database
            * You can connect to it using a shell client or even a driver like ODBC 
        * Oozie
            * A way of scheduling jobs in your cluster
            * More complicated operations 
        * Zookeeper
            * Coordinating everything in your cluster
            * Which nodes are up, which nodes are down
            * Keeping track of who the master node is
        * Apache Ambari (used by Hortonworks)
            * Sits on top of everything
            * Lets us have an overview of everything in your cluster
                * How much resources
                * What is up and running?
            * View of the cluster
        * **Data Ingestion**
            * How you get data into your cluster
            * Scoop
                * A tool that enables anything that communicates using ODBC, JDBC (realtional database) to Hadoop
                * A connector between Hadoop and your legacy databases
            * Flume
                * A way of transporting web logs
                * Group of web services, get those logs and get those inside the cluster
            * Kafka
                * Collect data from any source and broadcast that to your hadoop cluster
    * External data storage (integrating with Hadoop cluster)
        * ![external-stores](./images/external-stores.PNG)
        * HBase also fits here
        * MySQL
            * Import / exports data with Scoop / Spark
        * Cassandra (key/value data store)
        * MongoDB (key/value data store)
    * Query Engines
        * ![query-engines](./images/query-engines.PNG)
        * Hive also fits here
        * Apache Drill 
            * Write SQL queries that works in a wide range of NoSQL dbs (HBase, Cassandra, MongoDB)
        * Hue
            * Creating queries with Hive and HBase
        * Apache Phoenix
            * Similar to Drills
            * Guarantees ACID
        * presto
        * Apache Zeppling
           
## HDFS and MapReduce

* Handling large files (broken up across a large cluster)
    * Breaking into blocks (128 megabytes blocks)
    * Stored across several commodity computers 
        * They may be even located nearby each other in the network to minimize reads/writes 
    * The same block will be saved in more than one computer, that way generating redundancy
        * If a node goes down, it is ok
    * ![hdfs-in-depth](./images/hdfs-in-depth.PNG)
        * Name node: This guy tracks where all those blocks live. It maintains a big table with the virtual file name, and it knows its associated blocks (which nodes it is stored in)
            * It also maintains an edit log (what is being created, what is being modified, what is being stored) to keep track where the blocks are
        * Data node: Store each block of each file
    * ![hdfs-reading-file](./images/hdfs-reading-file.PNG)
        * We have a `Client Node` running our application
        * First thing it will do is to talk to the `Name Node` asking for a specific file
            * The `Name Node` will come back with a list of blocks and `Data Nodes` where they are located.
            * It will also optimize this list with the best `Data Nodes` based on your location in the network
        * Finally, the client application will reach the `Data Nodes` in order to retrieve the blocks
    * ![write-file-hdfs](./images/write-file-hdfs.PNG)
        * Whenever you create a file your `Client Node` will first reach out to the `Name Node` in order to update his table. 
        * After that, the `Client Node` will reach to one of the `Data Nodes` in order to write the blocks. On that note, the `Data Node` will talk to other `Data Nodes` and distribute the blocks among them
            * The `Data Nodes` talk to each other in order to store the file
        * As soon as the file is saved, the `Data Node` sends a message back to the `Client Node`, and right after that the `Client Node` communicates the change to the `Name Node`.
    * ![name-node-backup](./images/name-node-backup.PNG) 
        * Back Up Metadata: `Name node` writes to local disk and NFS
            * NFS: Network File System
        * Secondary Name Node: Maintains merged copy of edit log you can restore from 
        * HDFS Federation: Each `Name Node` manages a specific namespace volume
            * HFS is optimized for large files, and not so much for lots and lots of small files. However, in case you have lots and lots of small files, maybe a `Name Node` will reach its limit.
                * So HDFS Federation lets you assign a `Name Node` for a specific name space volume. 
            * This is not a backup technic, but at least in this situation you would not lose all of your data.
        * HDFS High Availability: 
            * Hot standby `Name Node` using shared edit log
                * No downtime. Your `Name Node` is actually writing to a share log in some reliable file system that is not HDFS. That way if your `Name Node` goes down, your hot `Name Node` will get in charge.
            * Zookeeper tracks active `Name Node`
            * Uses extreme measures to ensure only one `Name Node` is used at a time
    * Using HDFS
        * UI (Ambari)
        * Command-Line Interface
        * HTTP / HDFS Proxies
            * An example is Ambari/File View
        * Java interface
        * NFS Gateway

* To SSH into our Hadoop cluster we will connect to:
    * `maria_dev@127.0.0.1` at port `2222`
        * This port was mapped by our Hortonworks proxy container
    * The password for this account is `maria_dev`
    * We can run `hadoop fs -ls` to list the files under `maria_dev` user.
    * To create a directory we will do `hadoop fs -mkdir ml-100k`
    * Lets get some data: `wget http://media.sundog-soft.com/hadoop/ml-100k/u.data`
        * `hadoop fs -copyFromLocal u.data ml-100k/u.data`
        * `hadoop fs -rm ml-100k/u.data`
        * `hadoop fs -rmdir ml-100k`

* Why MapReduce?
    * Distributes the processing of data on your cluster
    * Divides your data up into partitions that are MAPPED (transformed) and REDUCED (aggregated) by mapper and reducer functions you define
    * Resilient to failure - an application master monitors your mappers and reducer on each partition

* ![map](./images/map.PNG) 
    * ![mapper](./images/map2.PNG) 
    * ![group](./images/map3.PNG) 
        * MapReduce will automatically group key/values and sort keys for you
    * ![reduce](./images/reduce.PNG)  

* ![map-reduce](./images/map-reduce.PNG)  
    * Client node will communicate with the HDFS in order to kick in any data retrieval needed.
    * `YARN` will be responsible to establish a `NodeManager` that will keep track of its other `Nodes` progress. Those other `Nodes` will be as close as possible to the `HDFS` data (data nodes). 
        * Minimize network traffic

* MapReduce is natively Java
    * STREAMING allows interface to other languages (ie Python)
    * ![streaming](./images/streaming.PNG)  
        * The `MapReduce` task will enable us to communicate with a separate streaming process. That other process we can write in Python, or another programming language.
        * ![mapper](./images/mapper.PNG) 
        * ![reducer](./images/reducer.PNG) 
        * ![map-reduce-streaming](./images/map-reduce-streaming.PNG) 
        * ![hdp-streaming](./images/hdp-streaming.PNG)
            * `su root`
                * password: `hadoop` 
            * After that install `pip` and all necessary packages
            * ![mrjob](./images/mrjob.PNG)
            * ```
                Streaming final output from hdfs:///user/maria_dev/tmp/mrjob/RatingsBreakdown.maria_dev.20190129.095308.285570/output...
                "1"     6111
                "2"     11370
                "3"     27145
                "4"     34174
                "5"     21203
                Removing HDFS temp directory hdfs:///user/maria_dev/tmp/mrjob/RatingsBreakdown.maria_dev.20190129.095308.285570...
                Removing temp directory /tmp/RatingsBreakdown.maria_dev.20190129.095308.285570...
              ```
            * ![multi-stage-mrjob](./images/multi-stage-mrjob.PNG) 
            * ![converting](./images/converting.PNG) 
            * ![solution-mrjob](./images/solution-mrjob.PNG) 

## Programming Hadoop with Pig

* Lets create a user to act as an `admin` inside `Ambari`
    * `su root`
    * `ambari-admin-password-reset`

* You now can access the `Pig View` by clicking the top right menu option.

* Scripting language called `Pig Latin` 
    * Creates MapReduce jobs without creating Mappers and Reducers
    * SQL-like syntax to define your map and reduce steps

* Sits on top of `MapReduce` or `Tez`, it can translate its scripts for both platforms:
    * `Tez` uses an acyclic graph to find the best path to get your data (10x faster than `MapReduce`)
    * `MapReduce` will run a series of Map->Reduce operations. 

* ![pig-relation](./images/pig-relation.PNG)
    * `Pig` is by default expecting tab limited data

* ![pig-relation2](./images/pig-relation-2.PNG) 
    * `DUMP metadata`: We just created a relation called `metadata` and we can print it to the screen by using the `DUMP` command
        * Good for debugging 

* ![pig-relation3](./images/pig-relation-3.PNG) 
    * Generate a new relation based on a previous relation

* ![pig-group](./images/pig-group.PNG) 
    * Looks like a reduce operation
    * ![pig-group2](./images/pig-group-2.PNG) 

* ![pig-filter](./images/pig-filter.PNG)

* ![pig-join](./images/pig-join.PNG)

* ![pig-order-by](./images/pig-order-by.PNG)

* ![pig-script](./images/pig-script.PNG)
    * Open `Ambari`, navigate to the `Pig View` and create the following script:
        * Remember to add the `ml-100k` to your user folder before running the script
        * ```
            ratings = LOAD '/user/maria_dev/ml-100k/u.data' AS (userID:int, movieID:int, rating:int, ratingTime:int);

            metadata = LOAD '/user/maria_dev/ml-100k/u.item' USING PigStorage('|') AS (movieID:int, movieTitle:chararray, releaseDate:chararray, videoRelease:chararray, imdbLink:chararray);

            nameLookup = FOREACH metadata GENERATE movieID, movieTitle, ToUnixTime(ToDate(releaseDate,'dd-MMM-yyyy')) as releaseTime;

            ratingsByMovie = GROUP ratings by movieID;

            avgRatings = FOREACH ratingsByMovie GENERATE group AS movieID, AVG(ratings.rating) AS avgRating;

            fiveStarMovies = FILTER avgRatings by avgRating > 4.0;

            fiveStarsWithData = JOIN fiveStarMovies by movieID, nameLookup by movieID;

            oldestFiveStarMovies = ORDER fiveStarsWithData BY nameLookup::releaseTime;

            DUMP oldestFiveStarMovies;
            ```
        * You can also run it using `Tez` by checking the `Execute on Tez` check box on the top right corner

* More about the Pig-latin language
    * ![pig-latin](./images/pig-latin.PNG) 
        * `STORE`: to store the results in HDFS
        * `MAPREDUCE`: lets you call actual Mappers and Reducers from `Pig`
        * `STREAM`: you can use stdin and stout to another process
    
    * ![pig-diagnostic](./images/pig-diagnostic.PNG)
        * `DESCRIBE`: Shows details of a relation (name and types)
        * `EXPLAIN`: Very much like a SQL explain plan (shows the steps to get and merge the data together)
        * `ILLUSTRATE`: Similar to `EXPLAIN`, it will show what is happening to the data in every single step

    * ![pig-udf](./images/pig-udf.PNG)
        * User-defined functions in Java
        * `REGISTER`: I have a jar file that contains my user defined function
        * `DEFINE`: Assigns names to the registered functions
        * `IMPORT`: Import macros (pig code you have done before). Similar to C macros

    * ![pig-func-loader](./images/pig-func-loader.PNG)
       
## Programming Hadoop with Spark

* A fast and general engine for large-scale data processing
    * Compared to `Pig`, this has a rich ecosystem that enables you to work with:
        * Machine Learning
        * Data Mining
        * Graph Analysis
        * Streaming Data

* ![spark-scalable](./images/spark-scalable.PNG)
    * `Driver Program`: Script that controls what is going to happen in your job
    * `Spark` can run on hadoop, but it can also run with other platforms. It can also use `Mesos`
        * Whatever Cluster Manager you choose, it will distribute the job across nodes
        * Process data in parallel 
        * `Spark` tries to retain as much as it can in RAM (Cache)
        * "Run programs up to 100x faster than Hadoop MapReduce in memory, or 10x faster on disk"
        * DAG Engine (directed acyclic graph) optimizes workflows
    

* Code in Python, Java or Scala
    * Build around one main concept: Resilient Distributed DataSet (RDD)
        * RDD is an object that represents a DataSet, and there are various functions you can call in that RDD object to transform it, or reduce it / analyze it.
        * Takes an RDD as input data, and transform it
    * Spark 2.0: They have built on top of RDDs to build something called DataSets

* ![spark-atmosphere](./images/spark-atmosphere.PNG) 
    * Spark Streaming: Imagine you have a group of web servers producing logs, you could ingest that data and analyze it in real time
    * Spark SQL: A SQL interface to Spark (really optimized)
    * MLLib: A library of Machine Learning and Data Mining tools that you can run in a data set that is in Spark
    * GraphX: Social graphs and other features

* ![spark-python](./images/spark-python.PNG)
    * ![spark-python-vs-scala](./images/spark-python-vs-scala.PNG)
    * `val nums = sc.parallelize(List[1,2,3,4])` is generating an RDD called nums

* RDD
    * Resilient
    * Distributed
    * Dataset
        * This is an object that knows how to manage it self on a cluster

* The SparkContext
    * You driver program will create a SparkContext
    * It is responsible for making RDD's resilient and distributed!
    * Creates RDD's
    * The Spark shell creates a "sc" object for you

* ![spark-rdd](./images/spark-create-rdd.PNG)

* ![spark-transform](./images/spark-transform.PNG) 
    * `map`: every input row of your RDD maps to an output row (1 to 1)
    * `flatmap`: will let you discard some input lines, or output more than one line for an entry (0..any to 0..any)
    * `filter`: Remove something from an RDD
    * `distinct`: Distinct unique values in an RDD
    * `sample`: Random sample
    * Similar to Pig, but more powerful

* Map example
    * ```python
        rdd = sc.parallelize([1,2,3,4])
        squaredRDD = rdd.map(lambda x: x*x)
      ```
    * This yields 1, 4, 9, 16

* ![spark-rdd-actions](./images/spark-rdd-actions.PNG) 
    * `collect`: Take all of the results of an RDD and suck them down to the Driver Script. Reduced it to something that can fit in memory
    * `count`: How many rows in RDD
    * `countByValue`: How many times a value occurs in your RDD
    * `take`: Take the top 10 results
    * `top`: Top few rows of an RDD
    * `reduce`: Define a function to reduce the data

* Lazy evaluation: Nothing actually happens in your driver program until an action is called

* Lets start with an example with the lower level RDD interface: Spark 1
    * Lower average rating movies
    * This script bellow is an example of a `Driver Script`
    * ```python
        from pyspark import SparkConf, SparkContext

        # This function just creates a Python "dictionary" we can later
        # use to convert movie ID's to movie names while printing out
        # the final results.
        def loadMovieNames():
            movieNames = {}
            with open("ml-100k/u.item") as f:
                for line in f:
                    fields = line.split('|')
                    movieNames[int(fields[0])] = fields[1]
            return movieNames

        # Take each line of u.data and convert it to (movieID, (rating, 1.0))
        # This way we can then add up all the ratings for each movie, and
        # the total number of ratings for each movie (which lets us compute the average)
        def parseInput(line):
            fields = line.split()
            return (int(fields[1]), (float(fields[2]), 1.0))

        if __name__ == "__main__":
            # The main script - create our SparkContext
            conf = SparkConf().setAppName("WorstMovies")
            sc = SparkContext(conf = conf)

            # Load up our movie ID -> movie name lookup table (local memory since it is small)
            movieNames = loadMovieNames()

            # Load up the raw u.data file (actual RDD)
            lines = sc.textFile("hdfs:///user/maria_dev/ml-100k/u.data")

            # Convert to (movieID, (rating, 1.0))
            movieRatings = lines.map(parseInput)

            # Reduce to (movieID, (sumOfRatings, totalRatings))
            ratingTotalsAndCount = movieRatings.reduceByKey(lambda movie1, movie2: ( mov                                                                     ie1[0] + movie2[0], movie1[1] + movie2[1] ) )

            # Map to (rating, averageRating)
            averageRatings = ratingTotalsAndCount.mapValues(lambda totalAndCount : total                                                                     AndCount[0] / totalAndCount[1])

            # Sort by average rating
            sortedMovies = averageRatings.sortBy(lambda x: x[1])

            # Take the top 10 results
            results = sortedMovies.take(10)

            # Print them out:
            for result in results:
        print(movieNames[result[0]], result[1])

        ```
    * `spark-submit LowestRatedMovieSpark.py`
        * ```
            SPARK_MAJOR_VERSION is set to 2, using Spark2
            ('3 Ninjas: High Noon At Mega Mountain (1998)', 1.0)
            ('Beyond Bedlam (1993)', 1.0)
            ('Power 98 (1995)', 1.0)
            ('Bloody Child, The (1996)', 1.0)
            ('Amityville: Dollhouse (1996)', 1.0)
            ('Babyfever (1994)', 1.0)
            ('Homage (1995)', 1.0)
            ('Somebody to Love (1994)', 1.0)
            ('Crude Oasis, The (1995)', 1.0)
            ('Every Other Weekend (1990)', 1.0)
            ```

* Lets know cover Spark 2.0
    * Spark 2.0 is going for a more structured data approach
    * Extends RDD to a "DataFrame" object
    * `DataFrames`:
        * Contain Row objects
            * Contains structured data
        * Can run SQL queries
        * Has a schema (leading to a more efficient storage)
        * Read and write to JSON, Hive, parquet
        * Communicates with JDBC/ODBC, Tableau
    * ![spark-in-python](./images/spark-in-python.PNG)
    * ![spark2-more](./images/spark2-more.PNG)
        * Remember, `Data Frames` are build on top of `RDDs`. So you can extract the underline RDD from it
    * ![spark2-dataset](./images/spark2-dataframe.PNG) 
    * ![spark2-sql-server](./images/spark2-sql-server.PNG)
    * ![spark2-udf](./images/spark2-udf.PNG)
    * RDD is the base/low level structure used in Spark to map/distribute data among a Spark cluster.

    * Dataset And Dataframe is a new abstraction API that allows the developer to work on a higher level that is more of tabular approach to your data, Dataset and Dataframe are backed by RDD.

    * The difference between dataset and dataframe is Dataset is strongly typed meaning you need to define the structure and type of fields during development.

    * Great post about RDDs, DataFrames and Datasets: https://databricks.com/blog/2016/07/14/a-tale-of-three-apache-spark-apis-rdds-dataframes-and-datasets.html
        * Starting in Spark 2.0, Dataset takes on two distinct APIs characteristics: a strongly-typed API and an untyped API, as shown in the table below. Conceptually, consider DataFrame as an alias for a collection of generic objects Dataset[Row], where a Row is a generic untyped JVM object. Dataset, by contrast, is a collection of strongly-typed JVM objects, dictated by a case class you define in Scala or a class in Java.

* Lets create a Spark 2 script:
    * ```python
            from pyspark.sql import SparkSession
            from pyspark.sql import Row
            from pyspark.sql import functions

            def loadMovieNames():
                movieNames = {}
                with open("ml-100k/u.item") as f:
                    for line in f:
                        fields = line.split('|')
                        movieNames[int(fields[0])] = fields[1]
                return movieNames

            def parseInput(line):
                fields = line.split()
                return Row(movieID = int(fields[1]), rating = float(fields[2]))

            if __name__ == "__main__":
                # Create a SparkSession (the config bit is only for Windows!)
                spark = SparkSession.builder.appName("PopularMovies").getOrCreate()

                # Load up our movie ID -> name dictionary
                movieNames = loadMovieNames()

                # Get the raw data
                lines = spark.sparkContext.textFile("hdfs:///user/maria_dev/ml-100k/u.data")
                # Convert it to a RDD of Row objects with (movieID, rating)
                movies = lines.map(parseInput)
                # Convert that to a DataFrame
                movieDataset = spark.createDataFrame(movies)

                # Compute average rating for each movieID
                averageRatings = movieDataset.groupBy("movieID").avg("rating")

                # Compute count of ratings for each movieID
                counts = movieDataset.groupBy("movieID").count()

                # Join the two together (We now have movieID, avg(rating), and count columns)
                averagesAndCounts = counts.join(averageRatings, "movieID")

                # Filter movies rated 10 or fewer times
                popularAveragesAndCounts = averagesAndCounts.filter("count > 10")

                # Pull the top 10 results
                topTen = popularAveragesAndCounts.orderBy("avg(rating)").take(10)

                # Print them out, converting movie ID's to names as we go.
                for movie in topTen:
                    print (movieNames[movie[0]], movie[1], movie[2])

                # Stop the session
                spark.stop()
        ```
    * `export SPARK_MAJOR_VERSION=2`
    * `spark-submit LowestRatedMovieDataFrame.py`
    * ```
        SPARK_MAJOR_VERSION is set to 2, using Spark2
        ('Amityville: A New Generation (1993)', 5, 1.0)
        ('Hostile Intentions (1994)', 1, 1.0)
        ('Lotto Land (1995)', 1, 1.0)
        ('Power 98 (1995)', 1, 1.0)
        ('Falling in Love Again (1980)', 2, 1.0)
        ('Careful (1992)', 1, 1.0)
        ('Low Life, The (1994)', 1, 1.0)
        ('Amityville: Dollhouse (1996)', 3, 1.0)
        ('Further Gesture, A (1996)', 1, 1.0)
        ('Touki Bouki (Journey of the Hyena) (1973)', 1, 1.0)
        ```

* On the next example lets do a movie recommendation script using `Spark 2.0` and the `MLLib`
    * ```python
        from pyspark.sql import SparkSession
        from pyspark.ml.recommendation import ALS
        from pyspark.sql import Row
        from pyspark.sql.functions import lit

        # Load up movie ID -> movie name dictionary
        def loadMovieNames():
            movieNames = {}
            with open("ml-100k/u.item") as f:
                for line in f:
                    fields = line.split('|')
                    movieNames[int(fields[0])] = fields[1].decode('ascii', 'ignore')
            return movieNames

        # Convert u.data lines into (userID, movieID, rating) rows
        def parseInput(line):
            fields = line.value.split()
            return Row(userID = int(fields[0]), movieID = int(fields[1]), rating = float(fields[2]))


        if __name__ == "__main__":
            # Create a SparkSession (the config bit is only for Windows!)
            spark = SparkSession.builder.appName("MovieRecs").getOrCreate()

            # Load up our movie ID -> name dictionary
            movieNames = loadMovieNames()

            # Get the raw data
            lines = spark.read.text("hdfs:///user/maria_dev/ml-100k/u.data").rdd

            # Convert it to a RDD of Row objects with (userID, movieID, rating)
            ratingsRDD = lines.map(parseInput)

            # Convert to a DataFrame and cache it
            ratings = spark.createDataFrame(ratingsRDD).cache()

            # Create an ALS collaborative filtering model from the complete data set
            als = ALS(maxIter=5, regParam=0.01, userCol="userID", itemCol="movieID", ratingCol="rating")
            model = als.fit(ratings)

            # Print out ratings from user 0:
            print("\nRatings for user ID 0:")
            userRatings = ratings.filter("userID = 0")
            for rating in userRatings.collect():
                print movieNames[rating['movieID']], rating['rating']

            print("\nTop 20 recommendations:")
            # Find movies rated more than 100 times
            ratingCounts = ratings.groupBy("movieID").count().filter("count > 100")
            # Construct a "test" dataframe for user 0 with every movie rated more than 100 times
            popularMovies = ratingCounts.select("movieID").withColumn('userID', lit(0))

            # Run our model on that list of popular movies for user ID 0
            recommendations = model.transform(popularMovies)

            # Get the top 20 movies with the highest predicted rating for this user
            topRecommendations = recommendations.sort(recommendations.prediction.desc()).take(20)

            for recommendation in topRecommendations:
                print (movieNames[recommendation['movieID']], recommendation['prediction'])

            spark.stop()
        ```

## Using relational data stores with Hadoop

* ![hive](./images/hive.PNG) 
* ![hive2](./images/hive2.PNG)
* ![hive3](./images/hive3.PNG)  
    * It is meant for data analysis (analytics), not to be used for real time transactional db.
    * OLTP: Online Transaction Process 
    * Hive is for OLAP (Online Analytical Processing)
    * Under the hood it is just Mappers and Reducers 
* ![hive4](./images/hive4.PNG)
    * Similar syntax as MySQL
* ![hive-in-action](./images/hive-in-action.PNG)
    * We can import files from HDFS or our local machine
    * After that, we can create views just like
        * ```sql
            CREATE VIEW IF NOT EXISTS topMovieIDs as 
            SELECT movieID, count(movieID) as ratingCount
            FROM ratings
            GROUP BY movieID
            ORDER BY ratingCount DESC;
            ```
            * This will get stored in HDFS as a "table" 
        * ```sql
            SELECT n.title, ratingCount
            FROM topMovieIDs t JOIN name n ON t.movieID = n.movieID;
            ```
        * `DROP VIEW topMovieIDs`

* SQL databases generally work with a `Schema on Write` approach. That means that we establish our table layout before inserting any data into the database. On the other hand, Hive works with a `Schema on Read` layout, where the data is not stored in a `Schema` fashion, but whenever we read it then we convert it to a `Schema`
    * Data is saved without actual structure
* ![hive-metada](./images/hive-metadata.PNG)
    * Without using Hive view in Ambari, those would be the steps needed to create the "table".

* ![hive-load](./images/hive-load.PNG)

* ![hive-partitioning](./images/hive-partitioning.PNG)

* ![hive-cli](./images/hive-cli.PNG)
    * In a nutshell, Hive is this SQL abstraction that makes our HDFS looks like a database. However, it is just a series of metafiles and actual files being crossed together. For this reason, this is NOT suitable for transaction systems (OLTP)

* How to integrate an actual MySQL database to your Hadoop cluster.
    * We will use Scoop to get MySQL data

* ![sqoop](./images/sqoop.PNG)
* ![sqoop2](./images/sqoop2.PNG)

* ![sqoop-hive](./images/sqoop-hive.PNG)
* ![sqoop-incremental](./images/sqoop-incremental.PNG)
* ![sqoop-mysql](./images/sqoop-mysql.PNG)
    * Note: Hive actually uses MySQL in order to work

## Using non-relation data store with Hadoop


* NoSQL 
    * Your high-transaction queries are probably pretty simple once de-normalized 
    * ![nosql-architecture](./images/nosql-architecture.PNG)
        * Each shard takes care of a subset of keys
        * For analytical queries we will still use SQL databases, they do a pretty good job at that. However, noSQL will help us scaling for online transactions (to server webapps, etc)
    * ![sample-architecture](./images/sample-architecture.PNG)
        * You may have a data source (web apps) feeding the system with data.
        * We will stream that data using Spark, generate some analysis on it and store that data in HDFS, but also send the processed data to MongoDB or some other NoSQL solution in order to answer questions quickly.

* HBase
    * Build on top of HDFS  
    * No query language, but it has an API (for CRUD)
    * Build on top of Big Table ideas from Google
    * ![ranges-of-keys](./images/ranges-of-keys.PNG)
        * Each server will take care of a range of keys (this is not a geographical filter)
            *  Just like sharding or partitioning 
        * The sharding (balancing the keys process) is done automatically
            * It does that by doing Write Ahead Commit logs and other strategies
            *  HBase will copy those individual rows inside each "Region" in a bigger file inside HDFS.
        * HMaster will keep track of your data schema, where things are stores, and how is it partitioned.
            * Mastermind of HBase
        * Zookeeper will keep track of HMasters so the cluster is always up and running properly even if some Node goes down.
    * Data Model
        * Fast access to any given ROW
        * A ROW is referenced by a unique KEY
        * Each ROW has some small number of COLUMN FAMILIES 
            * A COLUMN FAMILY may contain arbitrary COLUMNS
            * You can have a very large number of COLUMNS in a COLUMN FAMILY
            * It is like having a list of values inside a ROW
        * Each CELL can have many VERSIONS with timestamps
        * Sparse data is A-OK - missing column in a row consumes no storage at all.
    * ![column-name-example](./images/column-name-example.PNG) 
    * ![column-name-example](./images/interface-hbase.PNG) 
    * ![hbase-example](./images/hbase-example.PNG)
        * For a specific UserID we will have a COLUMN FAMILY (list) of ratings.
            * `{ movieId: rating }`
    * ![hbase-rest](./images/hbase-rest.PNG)
        * Remember that HBase Regions are near to the appropriate Data Nodes they need to communicate to. They are always minimizing network calls.
            * Region server may be running on the same server as a Data Node. This is data locality 
    * ![mongo-vs-hbase](./images/mongo-vs-hbase.PNG)
    * Script inside `HadoopMaterials/HBaseExamples.py`
        * ```python
            # Remember to start HBase inside Ambari
            # you also need to ssh into the machine and start the server as root
            # su root
            # /usr/hdp/current/hbase-master/bin/hbase-daemon.sh start rest 8000 --infoport 8001
            # Remember to open port 8000
            from starbase import Connection

            c = Connection("127.0.0.1", "8000")

            ratings = c.table('ratings') # Creates a COLUMN FAMILY 

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
            ```