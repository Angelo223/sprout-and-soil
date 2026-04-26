# Godot UI Integration Plan – Sprout & Soil

## 1. Ziel

Dieses Dokument beschreibt, wie der visuelle Stil des aktuellen Mockups modular in Godot eingebaut werden soll.

Wichtig: Der Mockup-Screen soll nicht als ein einziges Hintergrundbild verwendet werden. Stattdessen wird der Look in einzelne wiederverwendbare Komponenten zerlegt.

Dadurch bleibt das Spiel:

- skalierbar
- wartbar
- erweiterbar
- responsiv für verschiedene Android-Geräte
- später gut animierbar

---

## 2. Grundentscheidung

## 2.1 Kein kompletter Screen als Bild

Der komplette Mockup-Screen dient als visuelle Referenz, aber nicht als direktes Ingame-Asset.

Ein einzelnes Vollbild hätte Nachteile:

- UI wäre nicht flexibel
- Buttons wären schwer klickbar zu machen
- verschiedene Displaygrößen wären problematisch
- spätere Erweiterungen wären aufwendig
- Animationen und Zustände wären schwer umzusetzen

## 2.2 Modularer Aufbau

Der Screen wird in folgende Bausteine zerlegt:

- Hintergrund / Gartenfläche
- Gartenraster
- einzelne Beete
- Pflanzen-Sprites
- Seed-Bar
- Seed-Karten
- Header-UI
- Dialoge und Feedback
- spätere Deko-Elemente

---

## 3. Ziel-Screen-Aufbau

Der Ingame-Screen soll grob so aufgebaut sein:

```text
MainScene
├─ BackgroundLayer
│  ├─ GrassBackground
│  └─ OptionalDecorationLayer
├─ WorldLayer
│  └─ GardenGrid
│     ├─ GardenTile_0_0
│     ├─ GardenTile_1_0
│     └─ ...
├─ UILayer
│  ├─ HeaderBar
│  ├─ HintLabel
│  └─ SeedBar
└─ OverlayLayer
   └─ DiscoveryDialog / FeedbackDialog
```

---

## 4. Empfohlene Node-Struktur

## 4.1 MainScene

`MainScene` bleibt der Einstiegspunkt.

Aufgabe:

- Szenenstruktur erzeugen oder halten
- Layer organisieren
- Verbindungen zwischen UI und Spiellogik herstellen

Nicht Aufgabe:

- einzelne Beete verwalten
- Pflanzenlogik direkt enthalten
- Pflanzenbeziehungen prüfen

Empfohlen:

```text
MainScene.tscn
└─ MainScene (Node2D)
   ├─ BackgroundLayer (Node2D)
   ├─ WorldLayer (Node2D)
   ├─ UILayer (CanvasLayer)
   └─ OverlayLayer (CanvasLayer)
```

---

## 4.2 BackgroundLayer

Der BackgroundLayer enthält die Gartenatmosphäre.

Kurzfristig:

- eine große grüne Fläche oder ein GrassBackground-Sprite

Später:

- Haus links oben
- Schild rechts oben
- Gießkanne
- Blumen
- Büsche
- kleine Deko-Elemente

Wichtig:

Diese Elemente dürfen nicht Teil der Spielmechanik sein. Sie sind nur Atmosphäre.

---

## 4.3 WorldLayer

Der WorldLayer enthält die spielrelevante Gartenfläche.

Dazu gehört:

- GardenGrid
- GardenTile-Nodes
- Pflanzen-Sprites
- spätere Status-Icons direkt am Beet

---

## 4.4 UILayer

Der UILayer enthält sichtbare Bedienoberfläche.

Dazu gehört:

- Header oben
- Hinweistext
- Seed-Bar unten
- Buttons
- Ressourcenanzeige

UILayer sollte als `CanvasLayer` umgesetzt werden, damit UI unabhängig von der Welt stabil bleibt.

---

## 4.5 OverlayLayer

Der OverlayLayer ist für temporäre Informationen.

Dazu gehört:

- Entdeckungsdialoge
- Ernte-Feedback
- Fehlermeldungen
- Tutorial-Hinweise
- spätere Pflanzen-Erklärungen

---

## 5. Gartenraster

## 5.1 Aktueller Stand

Aktuell erzeugt `GardenGrid` zur Laufzeit ein 3x3-Raster mit Button-basierten GardenTiles.

Das war für den Prototyp gut, soll aber mittelfristig ersetzt werden.

## 5.2 Zielzustand

Jedes Beet soll eine eigene Szene werden:

```text
scenes/garden/GardenTile.tscn
```

Empfohlener Aufbau:

```text
GardenTile (Area2D oder Node2D)
├─ BedSprite (Sprite2D)
├─ PlantSprite (Sprite2D)
├─ StatusIcon (Sprite2D)
└─ ClickArea (Area2D / CollisionShape2D)
```

Alternative für sehr UI-lastige Umsetzung:

```text
GardenTile (Control)
├─ BedTexture (TextureRect)
├─ PlantTexture (TextureRect)
├─ StatusIcon (TextureRect)
└─ Button / TextureButton
```

## 5.3 Empfehlung

Für dieses Spiel ist kurzfristig `Control`/`TextureButton` einfacher.

Langfristig kann `Node2D`/`Area2D` besser sein, falls mehr Animation, Partikel und Weltgefühl entstehen soll.

Aktuelle Empfehlung:

- MVP: `Control` oder `TextureButton`
- später: bei Bedarf zu `Node2D`/`Area2D` wechseln

Da das aktuelle Projekt bereits mit UI-Buttons funktioniert, ist ein schrittweiser Umbau sinnvoll.

---

## 6. GardenTile Visuals

## 6.1 GardenTile-Zustände

Ein GardenTile sollte folgende Daten halten:

- `tile_index`
- `grid_position`
- `plant_id`
- `growth_day`
- `health`
- `water_state`
- später: `relationship_state`

## 6.2 Darstellung

Das Tile soll nicht mehr nur Text anzeigen.

Ziel:

- Beet-Textur im Hintergrund
- Pflanzen-Sprite darüber
- optional kleines Status-Icon
- Debug-Text nur optional

Beispiel:

```text
Empty Tile:
- tile_bed_empty.png
- kein PlantSprite

Planted Tile:
- tile_bed_planted.png
- plant_carrot_stage_01.png

Ready Tile:
- tile_bed_ready.png
- plant_carrot_stage_04.png
- optional glow/status icon
```

---

## 7. Seed-Bar

## 7.1 Aktueller Stand

Die Seed-Bar wird aktuell per Code als `HBoxContainer` mit Buttons erzeugt.

## 7.2 Zielzustand

Die Seed-Bar soll visuell wie im Mockup aussehen:

```text
SeedBar (Control)
├─ BackgroundPanel (TextureRect)
├─ SeedSlot_Carrot (TextureButton / Control)
├─ SeedSlot_Onion
├─ SeedSlot_Tomato
└─ SeedSlot_Basil
```

Jeder SeedSlot:

```text
SeedSlot (Control)
├─ SlotBackground (TextureRect)
├─ PlantIcon (TextureRect)
├─ NameLabel (Label)
└─ CountLabel / OptionalInfo
```

## 7.3 Selected State

Der ausgewählte SeedSlot nutzt:

```text
ui_seed_slot_selected.png
```

Normale SeedSlots nutzen:

```text
ui_seed_slot.png
```

Der ausgewählte Slot soll klar erkennbar sein durch:

- goldenen Rand
- leichten Glow
- ggf. kleine Spitze/Marker unten

---

## 8. Header-UI

## 8.1 Kurzfristig

Der Header kann schlicht bleiben:

- Titel
- Hinweistext

## 8.2 Mittelfristig

Wie im Mockup:

```text
HeaderBar
├─ LeafCurrencyPanel
├─ SettingsButton
└─ OptionalTitle / Logo
```

## 8.3 Wichtig

Der Titel muss später nicht dauerhaft groß im Spielscreen bleiben.

Für echte Gameplay-Screens kann der Platz besser genutzt werden für:

- Tagesanzeige
- Ressourcen
- Tagebuch-Button
- Settings

Der große Titel eignet sich eher für:

- Startscreen
- Main Menu
- Onboarding

---

## 9. Hintergrund und Deko

## 9.1 Hintergrund

Kurzfristig:

- `tile_grass_base.png` oder ein großes GrassBackground-Sprite

Mittelfristig:

- weich gemalter Gartenhintergrund
- Randdeko
- kleine Blumen
- Deko-Objekte

## 9.2 Deko-Elemente

Deko aus dem Mockup soll später als einzelne Assets umgesetzt werden:

- kleines Haus
- Holzschild
- Gießkanne
- Blumentöpfe
- Büsche
- Zaun
- Steine

Diese sollten nicht sofort priorisiert werden.

---

## 10. Asset-Integration

## 10.1 Zielordner

```text
assets/
├─ ui/
│  ├─ seed_bar/
│  ├─ panels/
│  └─ icons/
├─ tiles/
│  ├─ ground/
│  └─ beds/
└─ plants/
   ├─ carrot/
   ├─ onion/
   ├─ tomato/
   └─ basil/
```

## 10.2 Erste konkrete Assets

```text
assets/tiles/ground/tile_grass_base.png
assets/tiles/beds/tile_bed_empty.png
assets/ui/seed_bar/ui_seed_slot.png
assets/ui/seed_bar/ui_seed_slot_selected.png
assets/plants/carrot/plant_carrot_stage_01.png
assets/plants/onion/plant_onion_stage_01.png
assets/plants/tomato/plant_tomato_stage_01.png
assets/plants/basil/plant_basil_stage_01.png
```

---

## 11. Technischer Umbauplan

## 11.1 Schritt 1 – Assets einfügen

- `assets/`-Ordner anlegen
- erste PNG-Dateien einfügen
- Godot importiert sie automatisch

## 11.2 Schritt 2 – GardenTile visuell umbauen

Aktuelles `GardenTile` basiert auf `Button`.

Kurzfristig kann das beibehalten werden, aber es sollte visuell erweitert werden:

- Button-Text reduzieren
- Hintergrundtextur setzen oder child TextureRect nutzen
- Pflanzensprite anzeigen

Empfohlener Zwischenschritt:

```gdscript
class_name GardenTile
extends TextureButton
```

Oder:

```gdscript
class_name GardenTile
extends Control
```

mit internem `TextureButton`.

## 11.3 Schritt 3 – PlantSprite-Mapping

`PlantData` sollte später nicht nur Namen enthalten, sondern auch Asset-Pfade.

Beispiel:

```gdscript
"carrot": {
    "display_name": "Carrot",
    "growth_days": 3,
    "stage_sprites": [
        "res://assets/plants/carrot/plant_carrot_stage_01.png",
        "res://assets/plants/carrot/plant_carrot_stage_02.png",
        "res://assets/plants/carrot/plant_carrot_stage_03.png",
        "res://assets/plants/carrot/plant_carrot_stage_04.png"
    ]
}
```

## 11.4 Schritt 4 – Seed-Bar als eigene Komponente

Aus `main_scene.gd` sollte die Seed-Bar später herausgelöst werden.

Ziel:

```text
scripts/ui/seed_bar.gd
scripts/ui/seed_slot.gd
```

Szenen:

```text
scenes/ui/SeedBar.tscn
scenes/ui/SeedSlot.tscn
```

## 11.5 Schritt 5 – MainScene vereinfachen

Langfristig soll `main_scene.gd` nur noch verbinden:

- SeedBar meldet ausgewählten Samen
- GardenGrid erhält ausgewählten Samen
- Dialogsystem zeigt Feedback

---

## 12. Empfohlene Zwischenarchitektur

Für den nächsten Umsetzungsschritt:

```text
MainScene
├─ BackgroundLayer
├─ GardenGrid
└─ SeedBar
```

Code-Verantwortung:

```text
main_scene.gd
- erstellt Hintergrund
- erstellt GardenGrid
- erstellt SeedBar
- verbindet Signale

garden_grid.gd
- erstellt Tiles
- merkt selected_seed_id
- pflanzt in leere Tiles

garden_tile.gd
- verwaltet Tile-Zustand
- aktualisiert visuelle Darstellung

plant_data.gd
- liefert Namen, Wachstumsdaten und später Sprite-Pfade
```

---

## 13. Reihenfolge für die Umsetzung

## Phase A – Asset-Ordner und Test-Assets

1. `assets/`-Ordnerstruktur anlegen
2. erste Texturen einfügen
3. prüfen, ob Godot sie importiert

## Phase B – GardenTile Visual Update

1. Beet-Texture anzeigen
2. Pflanzen-Texture anzeigen
3. Textlabel nur noch optional/debug

## Phase C – Seed-Bar Visual Update

1. Seed-Slot-Hintergrundtexturen einbauen
2. ausgewählten Slot hervorheben
3. Pflanzen-Icons integrieren

## Phase D – Polish

1. kleine Animation beim Pflanzen
2. leichte Auswahlanimation bei Seed-Wechsel
3. sanfter visueller Feedback-Effekt

---

## 14. Risiken

## 14.1 Zu frühes Overengineering

Noch keine komplexe UI-Architektur bauen, bevor klar ist, wie sich das Spiel anfühlt.

## 14.2 Zu viele Assets auf einmal

Erst die sichtbaren Hauptteile ersetzen:

- Beet
- Gras
- Seed-Slots
- erste Pflanzen

## 14.3 Uneinheitlicher Stil

Alle neuen Assets müssen an der Art Direction und am Mockup ausgerichtet werden.

---

## 15. Konkreter nächster Schritt

Als nächstes sollten die ersten PNG-Assets in das Repo aufgenommen werden.

Danach wird `GardenTile` so umgebaut, dass es statt reinem Text echte Texturen und Pflanzen-Sprites anzeigen kann.

Minimalziel:

- Gras-Hintergrund sichtbar
- Beet-Textur sichtbar
- Seed-Bar visuell besser
- gewählte Pflanze erscheint als Sprite auf dem Beet
