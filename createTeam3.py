import rpy2.robjects as ro
from sets import Set

def createTeams(teamNames,pos):
    allTeams = {}
    for name in teamNames:
        allTeams[name] = list(playerIndex(name,pos))
    return allTeams


def beamSearch(myTeam, otherTeams, playerTrade,teamTrade,depth):
    global beamWidth
    global solutions
    global solutionsCost


    # Initial Startup
    print "\n\nDepth 1 \n\n"
    dfs(myTeam,otherTeams,playerTrade,teamTrade,0)
    costs = sorted(solutionsCost.values(),reverse=True)
    costs = costs[:beamWidth]

    for i in range(2,depth+1):
        print "\n\n Depth " + str(i) + "\n\n"
        numSearches = 0
        solutionsCopy = solutions.copy()
        solutions = {}
        solutionsCosts = {}

        
        for key,value in solutionsCopy.iteritems():
            if numSearches > beamWidth:
                break
            elif value['percentageWin'] in costs:
                numSearches += 1
                dfs(value['myTeam'],value['otherTeams'],value['playerTrade'],value['teamTrade'],depth=0)
                costs = sorted(solutionsCost.values(),reverse=True) 
                costs = costs[:beamWidth]

    # solutions printed automatically in script


def dfs(myTeam, otherTeams, playerTrade, teamTrade, depth):
    global solutions
    global solutionsCost
    global possibleTradesPlayer
    global numRValueCalls


    
    
    
    if depth == 1 or len(myTeam) == 0:
        playerSet = Set(playerTrade)
        if playerSet not in possibleTradesPlayer:
            possibleTradesPlayer.append(playerSet)
            #possibleTradesTeam.append(teamTrade)
            percentageWin = reassignmentValue(myTeamName,playerTrade,teamTrade)[0]
            numRValueCalls += 1
            print percentageWin
            myTeamCp = list(myTeam)
            otherTeamsCp = dict(otherTeams)
            teamTradeCp = list(teamTrade)
            playerTradeCp = list(playerTrade)
            solutions[str(playerTrade)] = {'myTeam' : myTeamCp, 'otherTeams' : otherTeamsCp, 'teamTrade' : teamTradeCp, 'playerTrade' : playerTradeCp, 'percentageWin':percentageWin}
            solutionsCost[str(playerTrade)] = percentageWin

        #else:
            #print "Player swappings already in set"
        return

   
    for playerIndex,player in enumerate(myTeam):
        
        # Remove my player
        myTeam.remove(player)

        for index,(teamName, team) in enumerate(otherTeams.iteritems()):
            for otherPlayerIndex,otherPlayer in enumerate(team):
                # Swap Players
                otherTeams[teamName].remove(otherPlayer)
                
                # 1. This would allow us to reswap, not necessary
                #otherTeams[teamName].insert(otherPlayerIndex,player)
                
                # 2. This would allow us to trade the player we just traded for
                #myTeam.insert(playerIndex,otherPlayer)
                
                myTeamCp = list(myTeam)
                otherTeamsCp = dict(otherTeams)
                dfs(myTeamCp,otherTeamsCp,playerTrade + [player,otherPlayer]\
                , teamTrade + [teamName,myTeamName],depth+1)

                #Undo swap
                # 1. otherTeams[teamName].remove(player)
                otherTeams[teamName].insert(otherPlayerIndex,otherPlayer)
                # 2. myTeam.remove(otherPlayer)
        
        #Re-add my player
        myTeam.insert(playerIndex,player)


# R Features and Initialization
f = file("search2.R")
code = ''.join(f.readlines())
result = ro.r(code)
swap = ro.r['swap']
playerIndex = ro.r['playerIndex']
getValue = ro.r['getValue']
reassignmentValue = ro.r['reassignmentValue']



#################################### Constants/Global Values ##########################
numRValueCalls = 0
DEBUG = 0
pos = "WR"
teamNames = ["ARI","ATL","BAL"]
myTeamName = 'ARI'
currWin = getValue(myTeamName)[0]
solutions = {}
solutionsCost = {}
possibleTradesPlayer = []
beamWidth = 3          ########## Change this for width of beam search
beamSearchDepth = 4    ########## Change this for depth of beam search

##################################### Setup #########################################
allTeams = createTeams(teamNames,pos)
print "\n\nStarting Values\n\n"
for key,value in allTeams.iteritems():
    print key,value
myTeam = allTeams[myTeamName]
del allTeams[myTeamName]
numPlayers = sum(len(value) for key,value in allTeams.iteritems())
print "Will be performing %d swaps\nEstimated times is %f mins" % \
(len(myTeam)*(numPlayers**2),float(len(myTeam)*(numPlayers**2))/60.0)

#################################### Main Section ###################################
# Begin search and Print Soltuion
beamSearch(myTeam, allTeams, [], [], beamSearchDepth)
costs = sorted(solutionsCost.values(),reverse=True)
maxCost = costs[0]

for key,value in solutions.iteritems():
    if value['percentageWin'] == maxCost:
        print key
        print value['percentageWin']


print "max cost " + str(maxCost)

######################################################################################
