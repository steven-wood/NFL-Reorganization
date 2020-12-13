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
binary variable twoTeamsPlay(teams, teams2, div);
binary variable x(teams, div);
free variable totalDist;
scalar bigM /1000/;

equations
    assignOne(teams,teams),
*    balanceDivisions(div),
*    twoTeamsPlaySet(teams, teams2, div),
    lim22Play(teams),
*    lim2Play(teams,div),
    balancePlay(teams,teams2,div),
    balanceDiv(div),
    last(teams,div),
    defObj
;

assignOne(teams,teams2)..
    sum(div, twoTeamsPlay(teams,teams2,div)) =L= 1;

*balanceDivisions(div)..
*    sum(teams, x(teams, div)) =E= 4;
    
*twoTeamsPlaySet(teams, teams2, div)..
*    x(teams, div) + x(teams2, div) - (bigM * twoTeamsPlay(teams,teams2)) =L= 2;
    
lim22Play(teams)..
    4 =E= sum((teams2,div), twoTeamsPlay(teams,teams2,div));
    
*lim2Play(teams2,div)..
*    4 =G= sum(teams, twoTeamsPlay(teams,teams2,div));
    
balancePlay(teams,teams2,div)..
    twoTeamsPlay(teams,teams2,div) =E= twoTeamsPlay(teams2,teams,div);

balanceDiv(div)..
    sum((teams,teams2), twoTeamsPlay(teams,teams2,div)) =E= 16;
    
last(teams,div)..
    sum(teams2, twoTeamsPlay(teams,teams2,div)) =E= 4*twoTeamsPlay(teams,teams,div);
    
defObj..
    totalDist =E= sum((teams, teams2, div), 2*twoTeamsPlay(teams, teams2, div)*dist(teams,teams2));
    
model NflReorg /all/;

solve NflReorg using mip min totalDist;

options twoTeamsPlay:0:0:1;
options x:0:1:1;
*display x.l;
display twoTeamsPlay.l;