import rpy2.robjects as ro
from sets import Set

def createTeams(teamNames,pos):
    allTeams = {}
    for name in teamNames:
        allTeams[name] = list(playerIndex(name,pos))
    return allTeams

def createPlayerNames(teams):
    names = {}
    for teamName,players in teams.iteritems():
        playerNames = getPlayersName(players)
        names[teamName] = list(playerNames)
    return names

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
        print "\n\nDepth " + str(i) + "\n\n"
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
    
    if depth == 1 or len(myTeam) == 0:
        playerSet = Set(playerTrade)
        if playerSet not in possibleTradesPlayer:
            possibleTradesPlayer.append(playerSet)
            #possibleTradesTeam.append(teamTrade)
            percentageWin = reassignmentValue(myTeamName,playerTrade,teamTrade)[0]
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


#################################### R Features and Initialization ######################
f = file("search2.R")
code = ''.join(f.readlines())
result = ro.r(code)
swap = ro.r['swap']
playerIndex = ro.r['playerIndex']
getValue = ro.r['getValue']
reassignmentValue = ro.r['reassignmentValue']
getPlayersName = ro.r['getPlayersName']


#################################### Constants/Global Values ##########################
DEBUG = 0
pos = ""
teamNames = []
myTeamName = ""
myTeam = []
solutions = {}
solutionsCost = {}
possibleTradesPlayer = []
beamWidth = -1          ########## Change this for width of beam search
beamSearchDepth = -1    ########## Change this for depth of beam search
playerNames = {}

##################################### Setup #########################################

def setup():
    global allTeams
    global playerNames
    global myTeam
    global myTeamName

    allTeams = createTeams(teamNames,pos)
    playerNames = createPlayerNames(allTeams)
    print "\n\nStarting Values\n"
    for teamName,players in playerNames.iteritems():
        print teamName
        for player in players:
            print "\t" + str(player)
    print "\n"
    for key,value in allTeams.iteritems():
        print key,value
    myTeam = allTeams[myTeamName]
    del allTeams[myTeamName]
    numPlayers = sum(len(value) for key,value in allTeams.iteritems())
    numSwaps = len(myTeam)*(numPlayers)+(beamSearchDepth-1)*beamWidth*len(myTeam)*numPlayers
    print "\nWill be performing approximately %d swaps\nEstimated times is %f mins" % \
    (numSwaps,float(numSwaps)/60.0)


#################################### Main Section ###################################
# Begin search and Print Soltuion
def getTeamFromName(player):
    for teamName,players in playerNames.iteritems():
        if player in players:
            return teamName


# Trades must be in format alternating between myTeam and otherTeam
def playersNamesFromTrades(trades):
    myPlayers = []
    tradedFor = []
    for index, playerNum in enumerate(trades):
        if index % 2 == 0:
            myPlayers.append(playerNum)
        else:
            tradedFor.append(playerNum)
        
    print "\nMy Players traded away from %s: " % (myTeamName)
    myPlayersNames = getPlayersName(myPlayers)
    for player in myPlayersNames:
        print player
    print "\n"
    
    print "Players Traded For: "
    playersTradedFor = getPlayersName(tradedFor)
    for player in playersTradedFor:
        print "%s from %s" % (player,getTeamFromName(player))
    print "\n"


def performDepthSearch():
    #global myTeam
    #global allTeams
    #global solutions

    beamSearch(myTeam, allTeams, [], [], beamSearchDepth)
    costs = sorted(solutionsCost.values(),reverse=True)
    maxCost = costs[0]

    solNum = 1
    for key,value in solutions.iteritems():
        if value['percentageWin'] == maxCost:
            print "Solution Number %d" % solNum
            print "Original numbers: " +str(key)
            playersNamesFromTrades(value['playerTrade'])
            solNum += 1

    print "\nBest Win Percentage " + str(maxCost) + "\n"



def main():
    global myTeamName
    global teamNames
    global allTeams
    global pos
    global beamWidth
    global beamSearchDepth

    pos = "WR"
    teamNames = ["ARI","ATL","BAL"]
    myTeamName = 'ARI'
    beamWidth = 3          ########## Change this for width of beam search
    beamSearchDepth = 2    ########## Change this for depth of beam search (Basically numers of trades)
    setup()
    
    '''
    Run performDepthSearch() to run a beam search with the variables above
    '''
    performDepthSearch()

    '''
    Run playerNamesFromTrades() with a list of alternating indexes representing trades
    Team Name of each index must be in teamNames[] in order to print out correctly
    This can be changed above
    '''
    #playersNamesFromTrades([975, 1026, 1496, 186])


if __name__ == "__main__":
    main()

