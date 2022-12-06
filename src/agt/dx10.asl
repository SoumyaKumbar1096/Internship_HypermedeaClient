

+!start: true

    <-
    .date(YY, MN, DD);
    .time(HH, MM, SS, MS);
    .send(monitor, achieve, logMessage(",[", DD, "-",MN ,"-",YY, "],[", HH,":",MM,":",SS,":",MS,"],","Agent DX10 is active"));
    !createArtifact ;  
.


+!createArtifact : 
    true
    <-
    
    makeArtifact(ld, "org.hypermedea.LinkedDataArtifact", [], LDArtId) ;
    focus(LDArtId) ;
       
    !crawl("http://localhost:3001/static/dx10td.ttl") ;
.

+!crawl(URI) :
    true
    <-
    get(URI) ;
    .wait({ +visited(_)});
    !displayProperties; 
    !checkConveyorBeltPaused; 
.

+!displayProperties : 
    true 
    <-
    for(rdf(S, P,"https://www.w3.org/2019/wot/td#PropertyAffordance")[crawler_source(URI)] & rdf(S, "https://www.w3.org/2019/wot/td#name", O)[crawler_source(URI)]){
        
        readProperty( O , Value)[artifact_name(dx10tda)] ;
        .print("Reading property: ",O," : ", Value) ;    
        +hasProperty(O);        
    } ;  
        
.



+!checkConveyorBeltPaused :
    hasProperty("M310.2")
    <-
    .date(YY, MN, DD);
    .time(HH, MM, SS, MS);
    .send(monitor, achieve, logMessage( ",[", DD, "-",MN ,"-",YY, "],[", HH,":",MM,":",SS,":",MS,"],","Time before Pause get request"));
    readProperty("M310.2", Paused)[artifact_name(dx10tda)];

    //.date(YY, MN, DD);
    .time(HHH, MMM, SSS, MSS);
    .send(monitor, achieve, logMessage( ",[", DD, "-",MN ,"-",YY, "],[", HHH,":",MMM,":",SSS,":",MSS,"],","Time after Pause get request"));
    
    if(Paused){
        .date(YY, MN, DD);
        .time(HH, MM, SS, MS);
        .send(monitor, achieve, logMessage( ",[", DD, "-",MN ,"-",YY, "],[", HH,":",MM,":",SS,":",MS,"],","Detected faulty conveyor belt"));
        
        readProperty("M6.6", EmptyTank)[artifact_name(dx10tda)];
        if(EmptyTank){
            
            !fillEmptyTank;
        }

        readProperty("I0.6", DownstreamAccumulation)[artifact_name(dx10tda)];
        
        if(DownstreamAccumulation){
            !clearDownstream;
        };
        
    }
   
    .wait(17000);   
    !checkConveyorBeltPaused;
.

+!clearDownstream: 
    ItemStuck
    <-
    .date(YY, MN, DD);
    .time(HH, MM, SS, MS);
    .send(monitor, achieve, logMessage(",[", DD, "-",MN ,"-",YY, "],[", HH,":",MM,":",SS,":",MS,"],","The conveyor belt is paused due to accumulation of object at the downstream"));
.

+!fillEmptyTank:
    EmptyTank
    <-
    .date(YY, MN, DD);
    .time(HH, MM, SS, MS);
    .send(monitor, achieve, logMessage(",[", DD, "-",MN ,"-",YY, "],[", HH,":",MM,":",SS,":",MS,"],","The conveyor belt is paused due to no product in the tank"));
.






{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
