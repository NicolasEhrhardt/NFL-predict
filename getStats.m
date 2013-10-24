function M = getStats(input, player, nbweeks)
  M = input.data( (player-1)*nbweeks + 1 : player * nbweeks, 3: end)';
end
