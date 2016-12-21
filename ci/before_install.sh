set -v

sudo sh -c 'echo "deb http://packages.2ndquadrant.com/pglogical/apt/ $(lsb_release -cs)-2ndquadrant main" > /etc/apt/sources.list.d/2ndquadrant.list'

wget --quiet -O - http://packages.2ndquadrant.com/pglogical/apt/AA7A6805.asc | sudo apt-key add -
sudo apt-get -y update
sudo apt-get -y install postgresql-9.5-pglogical

echo -e "wal_level = 'logical'\nmax_worker_processes = 10\nmax_replication_slots = 10\nmax_wal_senders = 10\nshared_preload_libraries = 'pglogical'" | sudo tee -a /etc/postgresql/9.5/main/postgresql.conf
echo -e "local replication all trust" | sudo tee -a /etc/postgresql/9.5/main/pg_hba.conf
sudo service postgresql restart 9.5

set +v
