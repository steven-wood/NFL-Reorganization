set div /1*8/,
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

alias(teams,teams2);
binary variable twoTeamsPlay(teams, teams2);
binary variable x(teams, div);
free variable totalDist;
scalar bigM /1000/;

*twoTeamsPlay.lo(teams,teams2) = 0;

equations
    assignOne(teams),
    balanceDivisions(div),
    twoTeamsPlaySet(teams, teams2, div),
    defObj
;

assignOne(teams)..
    sum(div, x(teams, div)) =E= 1;

balanceDivisions(div)..
    sum(teams, x(teams, div)) =E= 4;
    
twoTeamsPlaySet(teams, teams2, div)..
    x(teams, div) + x(teams2, div) - (bigM * twoTeamsPlay(teams,teams2)) =L= 2;
    
defObj..
    totalDist =E= sum((teams, teams2), twoTeamsPlay(teams, teams2)*dist(teams,teams2));
    
model NflReorg /all/;

solve NflReorg using mip max totalDist;

options x:2:1:1;
display x.l;