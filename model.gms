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

equations
    assignOne(teams),
    balanceDivisions(div),
    twoTeamsPlaySet(teams, teams2, div),
    lim22Play(teams),
    lim2Play(teams),
    balancePlay(teams,teams2),
    defObj
;

assignOne(teams)..
    sum(div, x(teams, div)) =E= 1;

balanceDivisions(div)..
    sum(teams, x(teams, div)) =E= 4;
    
twoTeamsPlaySet(teams, teams2, div)..
    x(teams, div) + x(teams2, div) - (bigM * twoTeamsPlay(teams,teams2)) =L= 2;
    
lim22Play(teams)..
    4 =E= sum(teams2, twoTeamsPlay(teams,teams2));
    
lim2Play(teams2)..
    4 =E= sum(teams, twoTeamsPlay(teams,teams2));
    
balancePlay(teams,teams2)..
    twoTeamsPlay(teams,teams2) =E= twoTeamsPlay(teams2,teams);
    
defObj..
    totalDist =E= sum((teams, teams2), 2*twoTeamsPlay(teams, teams2)*dist(teams,teams2));
    
model NflReorg /all/;

solve NflReorg using mip min totalDist;

options twoTeamsPlay:0:1:1;
display twoTeamsPlay.l;