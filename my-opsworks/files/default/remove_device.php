#!/usr/bin/php -q
<?php
/*
 +-------------------------------------------------------------------------+
 | Copyright (C) 2004-2009 The Cacti Group                                 |
 |                                                                         |
 | This program is free software; you can redistribute it and/or           |
 | modify it under the terms of the GNU General Public License             |
 | as published by the Free Software Foundation; either version 2          |
 | of the License, or (at your option) any later version.                  |
 |                                                                         |
 | This program is distributed in the hope that it will be useful,         |
 | but WITHOUT ANY WARRANTY; without even the implied warranty of          |
 | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           |
 | GNU General Public License for more details.                            |
 +-------------------------------------------------------------------------+
 | Cacti: The Complete RRDTool-based Graphing Solution                     |
 +-------------------------------------------------------------------------+
 | This code is designed, written, and maintained by the Cacti Group. See  |
 | about.php and/or the AUTHORS file for specific developer information.   |
 +-------------------------------------------------------------------------+
 | http://www.cacti.net/                                                   |
 +-------------------------------------------------------------------------+
*/

/* do NOT run this script through a web browser */
if (!isset($_SERVER["argv"][0]) || isset($_SERVER['REQUEST_METHOD'])  || isset($_SERVER['REMOTE_ADDR'])) {
	die("<br><strong>This script is only meant to run at the command line.</strong>");
} 
 
/* We are not talking to the browser */
$no_http_headers = true;

include(dirname(__FILE__)."/../include/global.php");
include_once($config["base_path"]."/lib/api_automation_tools.php");
include_once($config["base_path"]."/lib/utility.php");
include_once($config["base_path"]."/lib/api_data_source.php");
include_once($config["base_path"]."/lib/api_graph.php");
include_once($config["base_path"]."/lib/snmp.php");
include_once($config["base_path"]."/lib/data_query.php");
include_once($config["base_path"]."/lib/api_device.php");

function getHostGraphIds($host_id) {

	$gids = db_fetch_assoc("SELECT id
		FROM graph_local
		WHERE graph_local.host_id=" . $host_id . "
		ORDER BY id");

	return $gids;
	
}

function getHostDataSourceIds($host_id) {

	$dsids = db_fetch_assoc("SELECT id
		FROM data_local
		WHERE data_local.host_id=" . $host_id . "
		ORDER BY id");

	return $dsids;
	
}

function array_flatten($array) {
   $flat = array();

   foreach ($array as $value) {
           if (is_array($value)) $flat = array_merge($flat, array_flatten($value));
           else $flat[] = $value;
   }
   return $flat;
} 


/* process calling arguments*/
$parms = $_SERVER["argv"];
array_shift($parms);

if (!sizeof($parms)) {
	display_help();
	exit(0);
}
/* set up defaults*/
$hosts          = getHosts();
$quietMode      = FALSE;

foreach($parms as $parameter) {
	@list($arg, $value) = @explode("=", $parameter);
		
	switch ($arg) {
		case "--device-id":
			if(!sizeof($value)){
				echo "ERROR: No device IDs supplied.\n";
				display_help();
				exit(1);
			}
			$dids = @explode(",", $value);		
			$a=1;
			foreach($dids as $did){
				if(!is_numeric($did)){
					echo "ERROR: Number $a in the supplied device ID is not a number.\n\n";
					display_help();
					exit(1);
				}
				if(!array_key_exists($did, $hosts)){
					echo "ERROR: Device ID $did does not exist. Aborting.\n\n";
					display_help();
					exit(1);
				}
				// Valid host, get graphs and data sources
				$gids[] = getHostGraphIds($did);
				$dsids[] = getHostDataSourceIds($did);
				$a++;
			}
			/* All keys are valid and exist, processing removes*/
			
			/* Flatten graph ID and data source ID arrays */
			$gids = array_flatten($gids);
			$dsids = array_flatten($dsids);
			
			/* Do the actual removes */
			api_data_source_remove_multi($dsids);
			api_graph_remove_multi($gids);
			api_device_remove_multi($dids);

			exit(0);
			break;
		case "--list-devices":
			displayHosts($hosts, $quietMode);
			exit(0);
			break;
		default:
			echo "ERROR: Missing or extraneous aruments.\n\n";
			display_help();
			exit(1);
	}

}


function display_help() {
	echo "Remove Device Script 0.2\n\n";
	echo "A very simple command line utility to remove a device or multiple devices from Cacti\n\n";
	echo "Remove device usage: remove_device.php --device-id=[device ids] \n";
	echo "Required:\n";
	echo "    --device-id    comma separated list of host/device IDs.\n\n";
	echo "List devices usage: remove_device.php --list-devices\n\n";
	echo "List Options:\n";
	echo "    --list-devices    Lists all devices\n\n";
}


?>
