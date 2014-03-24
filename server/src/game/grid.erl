-module(grid).

-export([build/0, cellsAvailable/1, randomAvailableCell/1, insertTile/3, availableCells/1, cellContent/2, removeTile/2, moveTile/3, size/0]).

-define(SIZE, 4).

size() ->
    ?SIZE.

build() ->
    [[null || _ <- lists:seq(1, ?SIZE)] || _ <- lists:seq(1, ?SIZE)].

availableCells(Grid) ->
    lists:append(
        setY(
            availableCells(Grid, 1)
        )
    ).

availableCells([Grid | Tail ], N) when is_list(Grid) ->
    [{availableCells(Grid, 1), N} | availableCells(Tail, N +1)];
availableCells([Grid | Tail ], N) ->
    case Grid =:= null of
        true -> [ N | availableCells(Tail, N +1)];
        false ->  availableCells(Tail, N +1)
    end;
availableCells([], _) ->
    [].

setY([{Cell, Y}|Tail]) -> 
    [ setY(Cell, Y) | setY(Tail)];
setY([]) -> 
    [].
setY([Head | Tail], Y) ->
    [ {Head, Y} | setY(Tail, Y)];
setY([], _) ->
    [].

cellsAvailable(Grid) ->
    length(availableCells(Grid)) > 0.

randomAvailableCell(Grid) ->
    Cells = availableCells(Grid),
    lists:nth(random:uniform(length(Cells)) ,Cells).

insertTile({X, Y}, Tile, Grid) ->
    Row = lists:nth(Y,Grid),
    lists:sublist(Grid,Y - 1) ++ [ lists:sublist(Row,X - 1) ++ [Tile] ++ lists:nthtail(X,Row)] ++ lists:nthtail(Y,Grid).

cellContent({ X, Y }, Grid) ->
    lists:nth(X,lists:nth(Y,Grid)).

removeTile({ X, Y }, Grid) ->
    Row = lists:nth(Y,Grid),
    lists:sublist(Grid,Y - 1) ++ [ lists:sublist(Row,X - 1) ++ [null] ++ lists:nthtail(X,Row)] ++ lists:nthtail(Y,Grid).

moveTile(Cell, Next, Grid) ->
    insertTile(Next, grid:cellContent(Cell), removeTile(Cell, Grid)).