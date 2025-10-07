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
