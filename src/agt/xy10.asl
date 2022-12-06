

+!start : 
    true
    <-
    .date(YY, MN, DD);
    .time(HH, MM, SS, MS);
    .send(monitor, achieve, logMessage( ",[", DD, "-",MN ,"-",YY, "],[", HH,":",MM,":",SS,":",MS,"],","Agent XY10 is active"));
    !createArtifact;
    
.


+!createArtifact : 
    true
    <-
    makeArtifact(xy10ld, "org.hypermedea.LinkedDataArtifact", [], LDArtId) ;
    focus(LDArtId) ;
    
    !crawl("http://localhost:3001/static/xy10td.ttl") ;
    
.

+!crawl(URI) :
    true
    <-
    get(URI) ;
    .wait({ +visited(_)}); 
    !displayProperties;
.

+!displayProperties     
    <-
    
    for(rdf(S, P,"https://www.w3.org/2019/wot/td#PropertyAffordance")[crawler_source(URI)] & rdf(S, "https://www.w3.org/2019/wot/td#name", O)[crawler_source(URI)]){
        
        readProperty( O , Value)[artifact_name(xy10tda)] ;
        .print("Reading property: ",O," : ", Value) ;    
        +hasProperty(xy10, O);        
    } ;  
    
    !checkSwitchPaused;
.

+!checkSwitchPaused :
    hasProperty(xy10,"I3.6") & hasProperty(xy10,"I3.7")
    <-
    readProperty("I3.6", Switch1)[artifact_name(xy10tda)];
    if(not Switch1){
        .date(YY, MN, DD);
        .time(HH, MM, SS, MS);
        .send(monitor, achieve, logMessage( ",[", DD, "-",MN ,"-",YY, "],[", HH,":",MM,":",SS,":",MS,"],","Switch is on pause"));
        !resolveSwitchPaused;
    }
    .wait(5000);
    !checkSwitchPaused;
.

+!resolveSwitchPaused
    <-
    readProperty("I2.4", TrayAtPickup)[artifact_name(xy10tda)];
    if(TrayAtPickup){
        .date(YY, MN, DD);
        .time(HH, MM, SS, MS);
        .send(monitor, achieve, logMessage(",[", DD, "-",MN ,"-",YY, "],[", HH,":",MM,":",SS,":",MS,"],","Pickup position empty. Fill the tray stack"));
        
    }
    
    readProperty("I2.6", TrayAtExit)[artifact_name(xy10tda)];
    if(TrayAtExit){
        .date(YY, MN, DD);
        .time(HH, MM, SS, MS);
        .send(monitor, achieve, logMessage( ",[", DD, "-",MN ,"-",YY, "],[", HH,":",MM,":",SS,":",MS,"],","Clear the exit"));
        
    }

    readProperty("I3.0", PotAtB8)[artifact_name(xy10tda)]
    if(PotAtB8){
        .date(YY, MN, DD);
        .time(HH, MM, SS, MS);
        .send(monitor, achieve, logMessage( ",[", DD, "-",MN ,"-",YY, "],[", HH,":",MM,":",SS,":",MS,"],","No pots at pot pickup position"));
        
    }
    
.
    



{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
