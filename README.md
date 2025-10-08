# Grandpa's Garden 🌱

Grandpa's Garden is a free-to-play, source-available RPG videogame telling the story of my life. 

It's written in Lua and built using the [LÖVE framework](https://love2d.org/).

## Table of contents
1. [TLDR](#tldr)
2. [About the game](#about-the-game)
3. [License](#license)
4. [How to contribute](#how-to-contribute)
5. [Issues & Feedback](#issues--feedback)
6. [Wiki](#wiki)
7. [Security](#security)
8. [Thank You](#thank-you)

## TLDR

Grandpa's Garden is source-available, free-to-play, and educational.

- You can read and study the code freely.
- Modifying, redistributing, or selling the game or any of its assets is strictly prohibited.
- Only contributions via [GitHub Pull Requests](https://github.com/EdoardoPorcaro/GrandpasGarden/pulls) will be considered.
- Follow the development and read updates in the [Discussions tab](https://github.com/EdoardoPorcaro/GrandpasGarden/discussions), and find detailed information in the [Wiki](https://github.com/EdoardoPorcaro/GrandpasGarden/wiki).

## About the game

Grandpa's Garden is a personal RPG project started from scratch.  

It combines narrative storytelling with traditional RPG mechanics.  

The game is open for exploration and study, but all assets and the core code remain protected under the LICENSE.

## License

Please [read the LICENSE carefully](./LICENSE.md) before using or interacting with Grandpa's Garden.

By playing the game, reading the code, or submitting contributions, you agree to abide by all terms described in the LICENSE.

## How to contribute

- All contributions must be submitted through [GitHub Pull Requests](https://github.com/EdoardoPorcaro/GrandpasGarden/pulls).
- Only bug fixes, code improvements, or suggestions that do not modify core assets will be considered.
- Follow the coding style used in the project (Lua + LÖVE framework).
- Detailed guidelines are available in [CONTRIBUTING.md](./CONTRIBUTING.md).

## Issues & Feedback

- Use [GitHub Issues](https://github.com/EdoardoPorcaro/GrandpasGarden/issues) to report bugs or request features.  
- Suggestions and feedback are welcome, but remember that assets cannot be redistributed or modified without explicit permission.  
- Check out the [Discussions tab](https://github.com/EdoardoPorcaro/GrandpasGarden/discussions) to follow development updates and ongoing conversations about the project.


## Wiki

The [Wiki](https://github.com/EdoardoPorcaro/GrandpasGarden/wiki) contains detailed information about:
- Game mechanics and rules
- Story, characters, and locations
- Technical details for those studying the code
- Guides for understanding and exploring Grandpa's Garden

## Security

If you discover any security vulnerabilities, please follow the instructions in [SECURITY.md](./SECURITY.md).

Do NOT publicly disclose issues before they are resolved to protect all users.  

## Thank You!

Thank you for your interest in Grandpa's Garden! 🌱

Enjoy exploring the game, learning from the code, and following its development.

*Edoardo Porcaro ⋅ 2025*

---

# Informazioni sul codice
In questa fase dello sviluppo, riporto qui alcune annotazioni su funzioni e tipi di dati/variabili.

## Indice
1. [Personaggi](#personaggi)
2. [Funzioni utili](#funzioni-utili)

## Personaggi
Le variabili che definiscono ciascun personaggio sono elencate e commentate di seguito.
| Nome della variabile | Tipo | Descrizione |
|--------------|--------------|-------------|
| `name`       | nome della variabile | Nome del personaggio |
| `x_pos`      | numero intero | Posizione lungo l'asse x del mondo di gioco |
| `y_pos`      | numero intero | Posizione lungo l'asse y del mondo di gioco |
| `walking_speed` | numero intero | Velocità a cui il personaggio cammina |
| `running_speed` | numero intero | Velocità a cui il personaggio corre |
| `fav_color`  | valore RGB | Colore con cui viene mostrato a schermo il nome del personaggio (`name`) nei dialoghi |
| `anim_state` | numero | Quale sprite (dallo spritesheet) è in uso in quell'esatto momento |
| `icon_state` | numero | Quale "icona" (goccia di sudore, lacrima, ecc) è da mostrare in quell'esatto momento |

La definizione puntuale di tutti i personaggi del gioco avviene nel file `npcs.lua`.

### Esempio
```lua
edoardo = { -- DEFINISCO LE PROPRIETÀ DI EDOARDO
  x_pos = 100, -- | all'inizio è posizionato
  y_pos = 50,  -- | al punto (100,50)
  walking_speed = 300, -- cammina a 300
  running_speed = 500, -- corre a 500
  fav_color = {0, 255, 0}, -- verde
  anim_state = 0, -- nessuna animazione
  icon_state = 0 -- nessuna icona
}
```

## Funzioni utili
In tutto il gioco vengono spesso fatti richiami a funzioni comuni molto utili per l'ordinaria gestione delle dinamiche basilari. Ecco riportati i dettagli di queste funzioni nella seguente tabella.
| Nome della funzione | Argomenti | Descrizione | Dov'è dichiarata |
| ------------------- | --------- | ----------- | ---------------- |
| `showDialogBox` | `npc_speaking` <sup>(→<code>npcs.lua</code>)</sup>, `dialog_title` <sup>(→<code>dialogs.lua</code>)</sup>, `effect` <sup>(→<code>dialog_effects.lua</code>)</sup> | Fa apparire sopra a `npc_speaking` il dialogo `dialog_title` con l'effetto `effect` | - |
| `dialogBoxTextPopupEffect` | `text_to_show` <sup>(→<code>dialog_title</code>→<code>dialogs.lua</code>)</sup>, `text_popup_speed` <sup>(→<code>game_settings.lua</code>)</sup> | Fa funzionare l'effetto di comparsa testo lettera a lettera classica degli RPG, dato il `text_to_show` da mostrare e la velocità `text_popup_speed` a cui mostrarne le lettere | funzione `showDialogBox` |
| `checkActionProximity` | `player` <sup>(→<code>npcs.lua</code>)</sup>, `npc` <sup>(→<code>npcs.lua</code>)</sup> | Controlla se il giocatore `player` è entro il raggio di azione dell'`npc`; per *azione* si intende ad esempio che il giocatore gli possa parlare | - |
| `cameraDeadZone` | `margin_top_bottom` <sup>(→<code>game_settings.lua</code>)</sup>, `margin_left_right` <sup>(→<code>game_settings.lua</code>)</sup> | Consente alla camera del gioco di spostarsi seguendo il giocatore, purché esso non si trovi all'interno della dead zone (che ha margine superiore/inferiore `margin_top_bottom` e sinistro/destro `margin_left_right` dai bordi della finestra del gioco) | - |

Il simbolo → indica in quale file tale argomento della funzione è originariamente definito.
