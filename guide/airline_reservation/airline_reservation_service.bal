// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/log;
import ballerina/mysql;
import ballerina/observe;
import ballerina/runtime;
import ballerina/sql;
//import ballerinax/docker;
//import ballerinax/kubernetes;

//@docker:Config {
//    registry: "ballerina.guides.io",
//    name: "airline_reservation_service",
//    tag: "v1.0"
//}
//
//@docker:Expose{}

//@kubernetes:Ingress {
//  hostname: "ballerina.guides.io",
//  name: "ballerina-guides-airline-reservation-service",
//  path: "/"
//}
//
//@kubernetes:Service {
//  serviceType: "NodePort",
//  name: "ballerina-guides-airline-reservation-service"
//}
//
//@kubernetes:Deployment {
//  image: "ballerina.guides.io/airline_reservation_service:v1.0",
//  name: "ballerina-guides-airline-reservation-service"
//}

// Service endpoint
endpoint http:Listener airlineEP {
    port: 9091
};

// Airline reservation service
@http:ServiceConfig {basePath: "/airline"}
service<http:Service> airlineReservationService bind airlineEP {

    // Resource 'flightQatar', which checks about airline 'Qatar Airways'
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/qatarAirways",
        consumes: ["application/json"],
        produces: ["application/json"]
    }
    flightQatar (endpoint caller, http:Request request) {
        http:Response response;
        json reqPayload;

        string resourcePath = "/airline/qatarAirways";
        log:printDebug("Received at : " + resourcePath);
        // Try parsing the JSON payload from the request
        match request.getJsonPayload() {
            // Valid JSON payload
            json payload => reqPayload = payload;
            // NOT a valid JSON payload
            error => {
                response.statusCode = 400;
                response.setJsonPayload({"Message" : "Invalid payload - Not a valid JSON payload"});
                caller->respond(response) but {error e => log:printError("Error sending response", err = e)};
                log:printWarn("Invalid payload at : " + resourcePath);
                done;
            }
        }

        string arrivalDate = <string> reqPayload.ArrivalDate but {error => ""};
        string departureDate = <string> reqPayload.DepartureDate but {error => ""};
        string rom = <string> reqPayload.From but {error => ""};
        string to = <string> reqPayload.To but {error => ""};
        string airline = "Qatar";

        // If payload parsing fails, send a "Bad Request" message as the response
        if (arrivalDate == "" || departureDate == "" || rom == "" || to == "") {
            response.statusCode = 400;
            response.setJsonPayload({"Message":"Bad Request - Invalid Payload"});
            caller->respond(response) but {error e => log:printError("Error sending response", err = e)};
            log:printWarn("Request with unsufficient info at : " + resourcePath + " : " + check request.getJsonPayload()!toString());
            done;
        }

        // Query the database to retrieve flight details
        json flightDetails = untaint airlineDBService(airline, departureDate, arrivalDate, to, rom);
        // Response payload
        log:printDebug("Response from Qatar : " + flightDetails.toString());
        response.setJsonPayload(flightDetails);
        // Send the response to the caller
        caller->respond(response) but {error e => log:printError("Error sending response", err = e)};
    }

    // Resource 'flightAsiana', which checks about airline 'Asiana'
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/asiana",
        consumes: ["application/json"],
        produces: ["application/json"]
    }
    flightAsiana (endpoint caller, http:Request request) {
        http:Response response;
        json reqPayload;

        string resourcePath = "/airline/asiana";
        log:printDebug("Received at : " + resourcePath);
        // Try parsing the JSON payload from the request
        match request.getJsonPayload() {
            // Valid JSON payload
            json payload => reqPayload = payload;
            // NOT a valid JSON payload
            error => {
                response.statusCode = 400;
                response.setJsonPayload({"Message" : "Invalid payload - Not a valid JSON payload"});
                caller->respond(response) but {error e => log:printError("Error sending response", err = e)};
                log:printWarn("Invalid payload at : " + resourcePath);
                done;
            }
        }

        string arrivalDate = <string> reqPayload.ArrivalDate but {error => ""};
        string departureDate = <string> reqPayload.DepartureDate but {error => ""};
        string rom = <string> reqPayload.From but {error => ""};
        string to = <string> reqPayload.To but {error => ""};
        string airline = "Asiana";

        // If payload parsing fails, send a "Bad Request" message as the response
        if (arrivalDate == "" || arrivalDate == "" || rom == "" || to == "") {
            response.statusCode = 400;
            response.setJsonPayload({"Message" : "Bad Request - Invalid Payload"});
            caller->respond(response) but {error e => log:printError("Error sending response", err = e)};
            log:printWarn("Request with unsufficient info at : " + resourcePath + " : " );
            done;
        }

        // Query the database to retrieve flight details
        json flightDetails = untaint airlineDBService(airline, departureDate, arrivalDate, to, rom);
        // Response payload
        log:printDebug("Response from Asiana : " + flightDetails.toString());
        response.setJsonPayload(flightDetails);
        // Send the response to the caller
        caller->respond(response) but {error e => log:printError("Error sending response", err = e)};
    }

    // Resource 'flightEmirates', which checks about airline 'Emirates'
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/emirates",
        consumes: ["application/json"],
        produces: ["application/json"]
    }
    flightEmirates (endpoint caller, http:Request request) {
        http:Response response;
        json reqPayload;

        string resourcePath = "/airline/emirates";
        log:printDebug("Received at : " + resourcePath);
        // Try parsing the JSON payload from the request
        match request.getJsonPayload() {
            // Valid JSON payload
            json payload => reqPayload = payload;
            // NOT a valid JSON payload
            error => {
                response.statusCode = 400;
                response.setJsonPayload({"Message" : "Invalid payload - Not a valid JSON payload"});
                caller->respond(response) but {error e => log:printError("Error sending response", err = e)};
                log:printWarn("Invalid payload at : " + resourcePath);
                done;
            }
        }

        string arrivalDate = <string> reqPayload.ArrivalDate but {error => ""};
        string departureDate = <string> reqPayload.DepartureDate but {error => ""};
        string rom = <string> reqPayload.From but {error => ""};
        string to = <string> reqPayload.To but {error => ""};
        string airline = "Emirates";

        // If payload parsing fails, send a "Bad Request" message as the response
        if (arrivalDate == "" || departureDate == "" || rom == "" || to == "") {
            response.statusCode = 400;
            response.setJsonPayload({"Message" : "Bad Request - Invalid Payload"});
            caller->respond(response) but {error e => log:printError("Error sending response", err = e)};
            log:printWarn("Request with unsufficient info at : " + resourcePath + " : " );
            done;
        }
        
        // Uncomment to observe the function execution time
        // int spanId = check observe:startSpan("Invoking airlineDBService function");
        // Query the database to retrieve flight details
        json flightDetails = untaint airlineDBService(airline, departureDate, arrivalDate, to, rom);
        // Uncomment to observe the function execution time
        // observe:finishSpan(spanId) but {error e => log:printError("Error finishing span", err = e)};
        // Response payload
        log:printDebug("Response from Emirates : " + flightDetails.toString());
        response.setJsonPayload(flightDetails);
        // Send the response to the caller
        caller->respond(response) but {error e => log:printError("Error sending response", err = e)};
    }
}

documentation{
    `Flight` record type holds information of each database result.
    F{{flightNo}} Flight number of selected flight
    F{{airline}} Name of the selected airline
    F{{arrivalDate}} Return date of selected flight
    F{{departureDate}} Departing date of selected flight
    F{{to}} Destination airport of selected flight
    F{{rom}} Departing airport of selected flight
}
type Flight record {
    int flightNo;
    string airline;
    string arrivalDate;
    string departureDate;
    string to;
    string rom;
    int price;
    !...
};

documentation {
    `airlineDBService` function constructs and executes queries on air line database.
    P{{airline}} Air line name
    P{{departureDate}} Planned departure date
    P{{arrivalDate}} Planned return date
    P{{to}} Destination airport
    P{{rom}} Departing airport
    R{{}} Returns a `Flight` record in json format
}
function airlineDBService (string airline, string departureDate, string arrivalDate, string to, string rom) returns (json) {
    // Database endpoint configuration moved inside the function to prevent the error on service startup when wrong 
    // database credentials are given.
    // Wrong credentials will be given to observe the results of no database connectivity.
    endpoint mysql:Client airLineDB {
        host: "localhost",
        port: 3306,
        name: "testdb2",
        username: "root",
        password: "root",
        dbOptions: { useSSL: false }
    };

    log:printDebug("Invoking airlineDBService with parameters - airline : " + airline + ", departureDate : " + departureDate 
    + ", arrivalDate : " + arrivalDate + ", to : " + to + ", from : " + rom);
    // Set arguments for the query
    sql:Parameter airlineParam = {sqlType:sql:TYPE_VARCHAR, value:airline};
    sql:Parameter departureDateParam = {sqlType:sql:TYPE_DATE, value:departureDate};
    sql:Parameter arrivalDateParam = {sqlType:sql:TYPE_DATE, value:arrivalDate};
    sql:Parameter toParam = {sqlType:sql:TYPE_VARCHAR, value:to};
    sql:Parameter fromParam = {sqlType:sql:TYPE_VARCHAR, value:rom};
    // Query to be executed
    string selectQuery = "SELECT * FROM FLIGHTS WHERE airline = ? AND departureDate = ? AND arrivalDate = ? AND dest = ? AND rom = ?";
    log:printDebug("airlineDBService query : " + selectQuery);
    // Uncomment this line and restart the service  to delay the service by 1 second
    // runtime:sleep(1000);
    var temp = airLineDB->select(selectQuery, Flight, airlineParam, departureDateParam, arrivalDateParam, toParam, fromParam);
    table<Flight> flights = check temp;
    Flight flight = {};
    foreach i in flights {
        flight.flightNo = i.flightNo;
        flight.airline = i.airline;
        flight.departureDate = i.departureDate;
        flight.arrivalDate = i.arrivalDate;
        flight.to = i.to;
        flight.rom = i.rom;
        flight.price = i.price;
    }
    log:printDebug("airlineDBService response : " );
    return <json> flight but {error => {}};
}
