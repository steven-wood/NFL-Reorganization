set conf /AFC, NFC/,
    div /NORTH, SOUTH, EAST, WEST/,
    teams;

$ call csv2gdx Coordinates.csv useHeader=y id=teams index=1
$gdxIn Coordinates.gdx
$load teams = teams
$gdxIn

parameter dist(teams, teams)
/
$ondelim
$include distances.csv
$offdelim
/;

alias(teams,i);
binary variable x(teams, conf, div);
variable divTotalDist(conf,div);
free variable totalDist;

equations
    assignOne(teams),
    balanceDivisions(conf,div),
*    divDist(conf,div,teams),
    defObj
;

assignOne(teams)..
    sum((conf,div), x(teams, conf, div)) =E= 1;

balanceDivisions(conf,div)..
    sum(teams, x(teams, conf, div)) =E= 4;
    
*divDist(conf,div,teams)..
*    divTotalDist(conf,div) =E= sum();
    
defObj..
    totalDist =E= 1;
*sum((conf,div), divTotalDist(conf,div));
    
model NflReorg /all/;

solve NflReorg using mip min totalDist;

*display divTotalDist.l;
option x:2:1:2;
display x.l;