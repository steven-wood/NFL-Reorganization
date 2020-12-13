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
binary variable x(teams, teams2, div);
free variable totalDist;

equations
    matchups(teams,teams),
    games(teams),
    matchupReflex(teams,teams2,div),
    balanceDiv(div),
    sameDiv(teams,div),
    defObj
;

matchups(teams,teams2)..
    sum(div, x(teams,teams2,div)) =L= 1;
    
games(teams)..
    4 =E= sum((teams2,div), x(teams,teams2,div));
    
matchupReflex(teams,teams2,div)..
    x(teams,teams2,div) =E= x(teams2,teams,div);

balanceDiv(div)..
    sum((teams,teams2), x(teams,teams2,div)) =E= 16;
    
sameDiv(teams,div)..
    sum(teams2, x(teams,teams2,div)) =E= 4*x(teams,teams,div);
    
defObj..
    totalDist =E= sum((teams, teams2, div), 2*x(teams, teams2, div)*dist(teams,teams2));
    
model NflReorg /all/;

solve NflReorg using mip min totalDist;

options x:0:0:1;
display x.l;

parameter y(teams,div);

loop((teams,div) $ (x.l(teams,teams,div) > 0),
    y(teams,div) = 1;

);
display y;