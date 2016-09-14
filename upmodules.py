#!/usr/bin/python3

import os
from docker import Client

cli = Client(base_url='unix://var/run/docker.sock')

print("Defining containers and images names...")


current_directory = os.getcwd()

images = {
	'database': 'database',
	'idehco3': 'new_idehco3_base:latest',
}

database_infos = { 
	'name': 'database2', 
	'port': 2346, 
	'internalport': 5432,
	'volume': os.path.join(current_directory, 'data')
}

apps_infos = [
	{ 'name': 'universal_user', 'volume': os.path.join(current_directory, 'apps/universal_user'), 	'port': 5000, 'internalport': 80 },
	{ 'name': 'community', 		'volume': os.path.join(current_directory, 'apps/community'), 		'port': 5001, 'internalport': 80 },
	{ 'name': 'mapping', 		'volume': os.path.join(current_directory, 'apps/mapping'), 			'port': 5002, 'internalport': 80 },
	{ 'name': 'bc_edgv', 		'volume': os.path.join(current_directory, 'apps/bc_edgv'),			'port': 5003, 'internalport': 80 },
	{ 'name': 'markers', 		'volume': os.path.join(current_directory, 'apps/markers'), 			'port': 5004, 'internalport': 80 }
]



print("Verifing the existence of root image...")
for image in images:
	if len(cli.images(name=images[image])) == 0:
		print("Error: there isn't the image "+images[image]+".")
		exit()



print("Starting database container...")
database_container = cli.create_container( 
	image=images['database'], 
	name=database_infos['name'],
	ports=[database_infos['internalport']], 
	host_config=cli.create_host_config(
		port_bindings={
	        database_infos['internalport']: database_infos['port'],
	    },
		binds={
			'/var/lib/postgresql/data': {
				'bind': os.path.join(current_directory, 'data'),
				'mode': 'rw',
			},
		}
	)
)
cli.start(container=database_container.get('Id'))
database_ip = cli.inspect_container(database_container.get('Id'))['NetworkSettings']['Networks']['bridge']['IPAddress']
print("The database is running on ip "+database_ip+":"+database_infos['internalport']+" and on localhost:"+database_infos['port'])



for app in apps_infos:
	print("Starting the "+app['name']+ " app...")
	app_container = cli.create_container(
		image=images['idehco3'],
		name=app['name'],
		dns=['146.164.34.2'],
		ports=[app['internalport']],
		environment={
			'IP_SGBD': database_ip
		},
		host_config=cli.create_host_config(
			port_bindings={ app['internalport']: app['port'] },
			binds={
				'/code': {
					'bind': app['volume']
				}
			}
		),
		command='/run2.sh'
	)
	cli.start(container=app_container.get('Id'))
	app_ip = cli.inspect_container(app_container.get('Id'))['NetworkSettings']['Networks']['bridge']['IPAddress']
	print("The "+app['name']+" app is running on ip "+app_ip+":"+app['internalport']+" and on localhost:"+app['port'])






