buildBoard = ->
    # board = []
    # for row in [0..3]
    #     board[row] = []
    #     console.log "row: ", row

    #     for column in [0..3]
    #         board[row][column] = 0
    #         console.log "column: ", column
    # board[boardArray[0][0],0,0,0]
    [0..3].map -> [0..3].map -> 0


randomInt = (x) ->
    Math.floor(Math.random() * x)

randomCellIndices = ->
    aero = [randomInt(4), randomInt(4)]

randomValue = ->
    values = [2,2,2,4]
    values[randomInt(4)]

generateTile = (board) ->
    value = randomValue()
    [row, column] = randomCellIndices()
    console.log "row: #{row} / col: #{column}"

    if board[row][column] is 0
        board[row][column] = value
    else
        generateTile(board)

    console.log "generate tile"

move = (board, direction) ->
    for i in [0..3]
        if direction is 'right'
            row = getRow(i, board)
            mergeCells(row, direction)
            collapseCells()

getRow = (z, board) ->
    console.log z
    printArray(board)
    [board[z][0], board[z][1], board[z][2], board[z][3]]


mergeCells = (row, direction) ->
    console.log "merge cells"
    if direction is "right"
        for a in [3...0]
            for b in [a-1..0]
                console.log a, b

collapseCells = ->
    console.log "collapse cells"


showBoard = (board) ->
    for row in [0..3]
        for col in [0..3]
            $(".r#{row}.c#{col} > div").html(board[row][col])
#
    console.log "show board"

printArray = (array) ->
    console.log "-- Start --"
    for row in array
        console.log row
    console.log "-- End --"


$ ->
    @board = buildBoard()
    generateTile(@board)
    generateTile(@board)
    printArray(@board)
    showBoard(@board)

  $('body').keydown (e) =>
    e.preventDefault()

    key = e.which
    keys = [37..40]

    if keys.indexOf (key) > -1
        console.log "key: #{key}"
        #continue the game
        direction = switch key
            when 37 then 'left'
            when 38 then 'up'
            when 39 then 'right'
            when 40 then 'down'
        console.log "direction: #{direction}"

        #try moving
        # debugger
        move(@board, direction)

        #check move validity

    else
        #do nothing