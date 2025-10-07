# Informazioni sul codice
In questa fase dello sviluppo, riporto qui alcune annotazioni su funzioni e tipi di dati/variabili.

## Personaggi
Le variabili che definiscono ciascun personaggio sono elencate e commentate di seguito.
| Nome della variabile | Tipo | Descrizione |
|--------------|--------------|-------------|
| `name`       | stringa       | Nome del personaggio |
| `x_pos`      | numero intero | Posizione lungo l'asse x del mondo di gioco |
| `y_pos`      | numero intero | Posizione lungo l'asse y del mondo di gioco |
| `fav_color`  | valore RGB | Colore con cui viene mostrato a schermo il nome del personaggio (`name`) nei dialoghi |
| `anim_state` | numero | Quale sprite (dallo spritesheet) è in uso in quell'esatto momento |
| `icon_state` | numero | Quale "icona" (goccia di sudore, lacrima, ecc) è da mostrare in quell'esatto momento |

La definizione puntuale di tutti i personaggi del gioco avviene nel file `npcs.lua`.

## Funzioni utili
In tutto il gioco vengono spesso fatti richiami a funzioni comuni molto utili per l'ordinaria gestione delle dinamiche basilari. Ecco riportati i dettagli di queste funzioni nella seguente tabella.
| Nome della funzione | Argomenti | Descrizione | Dov'è dichiarata |
| ------------------- | --------- | ----------- | ---------------- |
| `showDialogBox` | `npc_speaking`, `dialog_title`, `effect` | Fa apparire sopra a `npc_speaking` (⇌ `npcs.lua`) il dialogo `dialog_title` (⇌ `dialogs.lua`) con l'effetto `effect` applicato (⇌ `dialog_effects.lua`) | - |
| `checkActionProximity` | `player`, `npc` | Controlla se il giocatore `player` (⇌ `npcs.lua`) è entro il raggio di azione dell'`npc` (⇌ `npcs.lua`); per *azione* si intende ad esempio che il giocatore gli possa parlare | - |
| `cameraDeadZone` | `margin_top_bottom`, `margin_left_right` | Consente alla camera del gioco di spostarsi seguendo il giocatore, purché esso non si trovi all'interno della dead zone (che ha margine superiore/inferiore `margin_top_bottom` (⇌ `game_settings.lua`) e sinistro/destro `margin_left_right` (⇌ `game_settings.lua`) dai margini della finestra del gioco | - |

Il simbolo ⇌ indica in quale file gli argomenti delle funzioni sono originariamente definiti.
