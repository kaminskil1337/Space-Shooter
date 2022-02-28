# Space Shooter

![Space Shooter](/README/README.gif)

## General info

Space Shooter is simple Ruby game that uses Gosu library. Your mission is to avoid and destroy meteorites, which follow you. With every destroyed meteorite you gain point, what makes meteorites fly faster. 

Leaderboard is a web application that is used to store, display and return high scores to game. You can access the leaderboard by this link: [Space Shooter Leaderboard](https://space-shooter-leaderboard.herokuapp.com/). Try to get the highest score 😃.

### Leaderboard

![In game leaderboard](/README/menu_leaderboard.png)

![Web app leaderboard](/README/web_leaderboard.png)

### Uploading new high score

![Uploading high score](/README/uploading_high_score.gif)


## How to start

[Install Ruby](https://rubyinstaller.org/downloads/)

in SpaceShooter folder:
```
gem install gosu
gem install httparty
game.rb
```

## To Do List

- [x] Online LeaderBoard
- [ ] Add features to game (power ups, repair kit, etc.)



## Technology used

[Gosu](https://www.libgosu.org/)

[Sinatra](http://sinatrarb.com/)

[httparty](https://github.com/jnunemaker/httparty)