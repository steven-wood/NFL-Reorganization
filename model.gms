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

*Current divsions

x.fx("Titans","Colts","1") = 1;
x.fx("Titans","Texans","1") = 1;
x.fx("Titans","Jaguars","1") = 1;
x.fx("Steelers","Browns","2") = 1;
x.fx("Steelers","Ravens","2") = 1;
x.fx("Steelers","Bengals","2") = 1;
x.fx("Chiefs","Raiders","3") = 1;
x.fx("Chiefs","Broncos","3") = 1;
x.fx("Chiefs","Chargers","3") = 1;
x.fx("Bills","Dolphins","4") = 1;
x.fx("Bills","Patriots","4") = 1;
x.fx("Bills","Jets","4") = 1;
x.fx("Giants","Washington","5") = 1;
x.fx("Giants","Eagles","5") = 1;
x.fx("Giants","Cowboys","5") = 1;
x.fx("Rams","Seahawks","6") = 1;
x.fx("Rams","Cardinals","6") = 1;
x.fx("Rams","Forty-Niners","6") = 1;
x.fx("Packers","Vikings","7") = 1;
x.fx("Packers","Bears","7") = 1;
x.fx("Packers","Lions","7") = 1;
x.fx("Saints","Buccaneers","8") = 1;
x.fx("Saints","Falcons","8") = 1;
x.fx("Saints","Panthers","8") = 1;

solve NflReorg using mip min totalDist;