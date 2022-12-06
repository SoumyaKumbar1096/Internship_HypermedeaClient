
+!start : 
    true
    <-
    .date(YY, MN, DD);
    .time(HH, MM, SS, MS);
    .send(monitor, achieve, logMessage( ",[", DD, "-",MN ,"-",YY, "],[", HH,":",MM,":",SS,":",MS,"],","Agent VL10 is active"));
    !createArtifact;
    
.

+!createArtifact:
    true
    <-
    makeArtifact(vl10ld, "org.hypermedea.LinkedDataArtifact", [], LDArtId) ;
    focus(LDArtId) ;
    !crawl("http://localhost:3001/static/vl10td.ttl") ;
    .print(" crawling vl10.ttl") .

+!crawl(URI) :
    true
    <-
    get(URI) ;
    .wait({ +visited(_)});
    !displayValues;
    !keepTrackOfPots;
    !checkConveyorBeltPaused ; 
.


+!displayValues : 
    true 
    <-
    for(rdf(S, P,"https://www.w3.org/2019/wot/td#PropertyAffordance")[crawler_source(URI)] & rdf(S, "https://www.w3.org/2019/wot/td#name", O)[crawler_source(URI)]){
        
        readProperty( O , Value)[artifact_name(vl10tda)] ;
        .print("Reading property: ",O," : ", Value) ;    
        +  hasProperty(O);
    } ;  
.

+!checkConveyorBeltPaused:
    hasProperty("I1.3")
    <-
    readProperty("I1.3", ConveyorStatus)[artifact_name(vl10tda)];
    if(ConveyorStatus){
        .date(YY, MN, DD);
        .time(HH, MM, SS, MS);
        .send(monitor, achieve, logMessage( ",[", DD, "-",MN ,"-",YY, "],[", HH,":",MM,":",SS,":",MS,"],","Conveyor Belt is on pause"));
        
        !resolveConveyorBelt;
    }
    
    .wait(5000);
    !checkConveyorBeltPaused;
.


//keep track of grabbing the pots by the Cartesain Robot
+!keepTrackOfPots
    <-
    readProperty("MW274", AtRack)[artifact_name(vl10tda)];
    
    .wait(240000)//wait for 4 mins

    if(AtRack < 8){
        !keepTrackOfPots;
    }
    elif(AtRack == 8){
        readProperty("MW276", PotPosition)[artifact_name(vl10tda)];
        .wait(300000) ; //wait for 4 more mins
        readProperty("MW274", AtRack)[artifact_name(vl10tda)];
        if(AtRack == 4){
            +rackEmpty;
        }
    }
.






+!resolveConveyorBelt
    <-
    readProperty("I1.2", AirLockClampStatus)[artifact_name(vl10tda)];
    readProperty("Q2.1", DoorsOpen)[artifact_name(vl10tda)]
    if(not AirLockClampStatus){
        .date(YY, MN, DD);
        .time(HH, MM, SS, MS);
        .send(monitor, achieve, logMessage(",[", DD, "-",MN ,"-",YY, "],[", HH,":",MM,":",SS,":",MS,"],","Pots accumulated at downstream"));
    }    
    elif(DoorsOpen){
        .date(YY, MN, DD);
        .time(HH, MM, SS, MS);
        .send(monitor, achieve, logMessage(",[", DD, "-",MN ,"-",YY, "],[", HH,":",MM,":",SS,":",MS,"],","Close the doors and reset the machine"));
    }
    elif(rackEmpty){
        .date(YY, MN, DD);
        .time(HH, MM, SS, MS);
        .send(monitor, achieve, logMessage(",[", DD, "-",MN ,"-",YY, "],[", HH,":",MM,":",SS,":",MS,"],","Fill the rack with pots and reset the machine"));
    }
.


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
