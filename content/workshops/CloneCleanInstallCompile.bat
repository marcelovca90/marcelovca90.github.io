git clone https://github.com/neo4j-contrib/developer-resources.git
cd .\developer-resources\language-guides\java\jdbc
call mvn clean
call mvn install
call mvn compile exec:java