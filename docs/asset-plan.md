# Asset Plan – Sprout & Soil

## 1. Ziel dieses Dokuments

Dieses Dokument definiert die erste konkrete Asset-Planung für **Sprout & Soil**.

Ziel ist, die benötigten Grafiken, UI-Elemente und Texturen so zu planen, dass das Projekt schrittweise professioneller wird, ohne sich zu früh in zu vielen Assets zu verlieren.

Der Fokus liegt zunächst auf einem kleinen, spielbaren und visuell konsistenten MVP.

---

## 2. Grundregeln für Assets

## 2.1 Stil

Alle Assets sollen zur Art Direction passen:

- cozy
- freundlich
- farbenfroh
- weich
- mobil gut lesbar
- nicht zu realistisch
- nicht zu kindlich
- keine harten schwarzen Outlines
- dezente Texturen statt Fotorealismus

## 2.2 Technische Regeln

- Format: PNG für Spielgrafiken und UI
- Transparenz: Pflanzen, Icons und UI-Elemente mit transparentem Hintergrund
- Einheitliche Canvas-Größen pro Asset-Kategorie
- Klare Dateinamen in Englisch
- Kleine Assets sollen auch auf Mobile gut erkennbar sein

## 2.3 Naming-Regeln

Dateinamen verwenden:

- lowercase
- underscores
- klare Kategorie am Anfang

Beispiele:

```text
plant_carrot_stage_01.png
tile_bed_empty.png
ui_button_primary.png
icon_water.png
```

---

## 3. Geplante Ordnerstruktur

```text
assets/
├─ ui/
│  ├─ buttons/
│  ├─ panels/
│  ├─ seed_bar/
│  └─ icons/
├─ tiles/
│  ├─ ground/
│  └─ beds/
├─ plants/
│  ├─ carrot/
│  ├─ onion/
│  ├─ tomato/
│  └─ basil/
└─ feedback/
   ├─ particles/
   └─ status/
```

---

## 4. Asset-Größen

Die Größen sind Startwerte und können später angepasst werden.

## 4.1 Tiles und Beete

Empfohlene Canvas-Größe:

```text
256x256 px
```

Begründung:

- passt gut zum aktuellen 3x3-Prototyp
- genügend Detail für Mobile
- leicht skalierbar
- später gut für Tile-Varianten nutzbar

## 4.2 Pflanzen

Empfohlene Canvas-Größe:

```text
256x256 px
```

Begründung:

- Pflanzen können sauber auf Beeten platziert werden
- gleiche Größe wie Beet-Tiles erleichtert Positionierung
- Wachstum kann innerhalb eines festen Rahmens dargestellt werden

## 4.3 UI-Icons

Empfohlene Größen:

```text
64x64 px
128x128 px
```

64x64 für kleine UI-Icons.
128x128 für größere Status- oder Seed-Icons.

## 4.4 UI-Panels und Buttons

Buttons und Panels sollten später möglichst 9-Slice-tauglich sein.

Startgrößen:

```text
ui_button_primary.png     320x96 px
ui_button_secondary.png   320x96 px
ui_panel_dialog.png       768x512 px
ui_seed_slot.png          192x224 px
```

---

## 5. Phase 1 – UI Foundation

Ziel: Die aktuelle funktionale UI durch einen klaren cozy Mobile-Look ersetzen.

## 5.1 Buttons

| Datei | Zweck | Priorität |
|---|---|---|
| `assets/ui/buttons/ui_button_primary.png` | Hauptbutton | Hoch |
| `assets/ui/buttons/ui_button_secondary.png` | Nebenbutton | Mittel |
| `assets/ui/buttons/ui_button_selected.png` | ausgewählter Zustand | Hoch |
| `assets/ui/buttons/ui_button_disabled.png` | deaktivierter Zustand | Mittel |

## 5.2 Panels

| Datei | Zweck | Priorität |
|---|---|---|
| `assets/ui/panels/ui_panel_dialog.png` | Dialoge und Erklärungen | Hoch |
| `assets/ui/panels/ui_panel_card.png` | Karten, Seed-Infos | Hoch |
| `assets/ui/panels/ui_panel_toast.png` | kleine Hinweise | Mittel |

## 5.3 Seed Bar

| Datei | Zweck | Priorität |
|---|---|---|
| `assets/ui/seed_bar/ui_seed_slot.png` | normaler Seed-Slot | Hoch |
| `assets/ui/seed_bar/ui_seed_slot_selected.png` | ausgewählter Seed-Slot | Hoch |
| `assets/ui/seed_bar/ui_seed_slot_locked.png` | später für gesperrte Seeds | Niedrig |

## 5.4 UI Icons

| Datei | Zweck | Priorität |
|---|---|---|
| `assets/ui/icons/icon_info.png` | Erklärung / Info | Hoch |
| `assets/ui/icons/icon_close.png` | Dialog schließen | Hoch |
| `assets/ui/icons/icon_confirm.png` | Bestätigen | Mittel |
| `assets/ui/icons/icon_back.png` | Zurück | Mittel |
| `assets/ui/icons/icon_diary.png` | Tagebuch / Discovery | Hoch |

---

## 6. Phase 2 – Garden Base

Ziel: Die grüne Testfläche und einfachen Buttons durch echte Gartenflächen ersetzen.

## 6.1 Ground Tiles

| Datei | Zweck | Priorität |
|---|---|---|
| `assets/tiles/ground/tile_grass_base.png` | Standard-Gras | Hoch |
| `assets/tiles/ground/tile_grass_variant_01.png` | leichte Variation | Mittel |
| `assets/tiles/ground/tile_path_soft.png` | weicher Gartenweg | Niedrig |

## 6.2 Bed Tiles

| Datei | Zweck | Priorität |
|---|---|---|
| `assets/tiles/beds/tile_bed_empty.png` | leeres Beet | Hoch |
| `assets/tiles/beds/tile_bed_planted.png` | bepflanztes Beet | Hoch |
| `assets/tiles/beds/tile_bed_watered.png` | gegossenes Beet | Mittel |
| `assets/tiles/beds/tile_bed_dry.png` | trockenes Beet | Mittel |
| `assets/tiles/beds/tile_bed_problem.png` | Problemzustand | Mittel |
| `assets/tiles/beds/tile_bed_ready.png` | erntebereit | Hoch |

---

## 7. Phase 3 – First Plants

Ziel: Die ersten vier Pflanzen visuell darstellen.

Alle Pflanzen bekommen zunächst vier Wachstumsstufen.

## 7.1 Carrot

| Datei | Zweck | Priorität |
|---|---|---|
| `assets/plants/carrot/plant_carrot_stage_01.png` | frisch gepflanzt / kleiner Sprout | Hoch |
| `assets/plants/carrot/plant_carrot_stage_02.png` | frühes Wachstum | Hoch |
| `assets/plants/carrot/plant_carrot_stage_03.png` | mittleres Wachstum | Hoch |
| `assets/plants/carrot/plant_carrot_stage_04.png` | reif / erntebereit | Hoch |
| `assets/plants/carrot/plant_carrot_sick.png` | krank / Problem | Mittel |

## 7.2 Onion

| Datei | Zweck | Priorität |
|---|---|---|
| `assets/plants/onion/plant_onion_stage_01.png` | frisch gepflanzt / kleiner Sprout | Hoch |
| `assets/plants/onion/plant_onion_stage_02.png` | frühes Wachstum | Hoch |
| `assets/plants/onion/plant_onion_stage_03.png` | mittleres Wachstum | Hoch |
| `assets/plants/onion/plant_onion_stage_04.png` | reif / erntebereit | Hoch |
| `assets/plants/onion/plant_onion_sick.png` | krank / Problem | Mittel |

## 7.3 Tomato

| Datei | Zweck | Priorität |
|---|---|---|
| `assets/plants/tomato/plant_tomato_stage_01.png` | frisch gepflanzt / kleiner Sprout | Hoch |
| `assets/plants/tomato/plant_tomato_stage_02.png` | frühes Wachstum | Hoch |
| `assets/plants/tomato/plant_tomato_stage_03.png` | mittleres Wachstum | Hoch |
| `assets/plants/tomato/plant_tomato_stage_04.png` | reif / erntebereit | Hoch |
| `assets/plants/tomato/plant_tomato_sick.png` | krank / Problem | Mittel |

## 7.4 Basil

| Datei | Zweck | Priorität |
|---|---|---|
| `assets/plants/basil/plant_basil_stage_01.png` | frisch gepflanzt / kleiner Sprout | Hoch |
| `assets/plants/basil/plant_basil_stage_02.png` | frühes Wachstum | Hoch |
| `assets/plants/basil/plant_basil_stage_03.png` | mittleres Wachstum | Hoch |
| `assets/plants/basil/plant_basil_stage_04.png` | reif / erntebereit | Hoch |
| `assets/plants/basil/plant_basil_sick.png` | krank / Problem | Mittel |

---

## 8. Phase 4 – Status und Feedback

Ziel: Spieler sollen Zustände und Ergebnisse intuitiv verstehen.

## 8.1 Status Icons

| Datei | Zweck | Priorität |
|---|---|---|
| `assets/feedback/status/icon_water.png` | Wasser / gegossen | Hoch |
| `assets/feedback/status/icon_dry.png` | trocken | Mittel |
| `assets/feedback/status/icon_pest.png` | Schädlingsbefall | Hoch |
| `assets/feedback/status/icon_healthy.png` | gesund | Mittel |
| `assets/feedback/status/icon_good_neighbor.png` | gute Nachbarschaft | Hoch |
| `assets/feedback/status/icon_bad_neighbor.png` | schlechte Nachbarschaft | Hoch |
| `assets/feedback/status/icon_discovery.png` | neue Entdeckung | Hoch |

## 8.2 Feedback Particles

| Datei | Zweck | Priorität |
|---|---|---|
| `assets/feedback/particles/particle_sparkle.png` | positives Feedback | Mittel |
| `assets/feedback/particles/particle_leaf.png` | sanfter Natur-Effekt | Niedrig |
| `assets/feedback/particles/particle_water_drop.png` | Gießen | Mittel |

---

## 9. MVP Asset Set

Das MVP benötigt nicht alle geplanten Assets.

Für den nächsten sichtbaren Qualitätssprung reichen:

## 9.1 Must-have

- `tile_grass_base.png`
- `tile_bed_empty.png`
- `tile_bed_planted.png`
- `ui_seed_slot.png`
- `ui_seed_slot_selected.png`
- `plant_carrot_stage_01.png`
- `plant_onion_stage_01.png`
- `plant_tomato_stage_01.png`
- `plant_basil_stage_01.png`

## 9.2 Should-have

- jeweils `stage_02` bis `stage_04` für die ersten vier Pflanzen
- `ui_panel_dialog.png`
- `icon_discovery.png`
- `icon_good_neighbor.png`
- `icon_bad_neighbor.png`
- `icon_pest.png`

## 9.3 Later

- kranke Pflanzenvarianten
- Deko
- Wege
- Partikel
- weitere Pflanzen
- saisonale Themes

---

## 10. Umsetzung in Godot

## 10.1 Kurzfristige Integration

Die aktuelle Button-basierte Darstellung kann schrittweise ersetzt werden.

Empfohlene Reihenfolge:

1. Beete visuell mit Texturen darstellen.
2. Seed-Bar visuell mit Seed-Slots darstellen.
3. Pflanzen-Sprites auf Beeten platzieren.
4. Textlabels reduzieren oder nur noch als Debug anzeigen.
5. Status-Icons und Feedback ergänzen.

## 10.2 Wichtig

Gameplay-Logik und Visuals sollten getrennt bleiben.

`GardenTile` sollte langfristig den Zustand verwalten, aber die Darstellung an eigene Child-Nodes oder Szenen delegieren.

---

## 11. Erste Produktionsrunde

Die erste Asset-Produktion sollte klein bleiben.

Empfohlenes erstes Paket:

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

Dieses Paket reicht aus, um den aktuellen Prototyp deutlich professioneller wirken zu lassen.

---

## 12. Offene Entscheidungen

Diese Punkte müssen noch final entschieden werden:

- Werden Beete reine Sprites oder echte TileMap-Tiles?
- Wird die Seed-Bar komplett als Control-UI gebaut oder teilweise als Sprite-UI?
- Werden Pflanzen später animiert oder zunächst nur als statische Sprites dargestellt?
- Wie groß sollen Touch-Ziele final sein?
- Soll das Spiel dauerhaft Portrait-orientiert bleiben?

Aktuelle Empfehlung:

- Portrait beibehalten
- UI als Control-Nodes
- Gartenfläche zunächst simpel als Node2D/Sprites weiterführen
- Pflanzen zuerst statisch, später optional animieren

---

## 13. Nächster Schritt

Als nächstes sollte ein erstes visuelles Testpaket erstellt werden:

1. Gras-Tile
2. leeres Beet
3. Seed-Slot normal
4. Seed-Slot selected
5. erste Stage-01-Pflanzen für Carrot, Onion, Tomato und Basil

Danach wird die aktuelle Button-Optik im Prototyp durch diese Assets ersetzt.
