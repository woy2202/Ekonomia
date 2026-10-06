# Uwagi o danych

## Wynagrodzenia (GUS BDL, zmienna 64428)
Przeciętne miesięczne wynagrodzenie brutto w podmiotach o liczbie
pracujących powyżej 9 osób. Wartości są wyższe niż oficjalna średnia
dla gospodarki narodowej (np. mazowieckie 2024: 10 018,71 zł vs 9 488,94 zł).
Zweryfikowano z rocznikiem statystycznym woj. lubelskiego 2024 (7 771,05 zł).

## Stopa bezrobocia rejestrowanego (GUS BDL, 60270 i 461680-461691)
Wartość roczna jest równa wartości z grudnia dla wszystkich województw
i lat (sprawdzone zapytaniem porównującym, 0 rozbieżności).

## Inflacja (GUS BDL, temat P2955, zmienne 217230-217236)
Roczny wskaźnik cen towarów i usług konsumpcyjnych, rok poprzedni = 100.
Klasyfikacja COICOP 1999, dane kończą się na 2025 r. Od 2026 r. GUS
publikuje inflację w nowej klasyfikacji COICOP 2018 (temat P4635, na razie
tylko kwartalnie). Po publikacji danych rocznych za 2026 r. trzeba dołączyć
nową serię i opisać sposób połączenia obu szeregów.

## Atrybuty wartości (GUS BDL, attr_id)
Wszystkie pobrane wartości mają attr_id = 1 i niepustą wartość
(sprawdzone 2026-10-06, 6944 wiersze). Kolumna jest zachowana w stagingu
na wypadek dodania zmiennych, w których pojawią się inne atrybuty.

## Zakres czasowy danych GUS
Część wskaźników (m.in. ludność) jest dostępna od 1995 r. Pierwotnie wymiar
dat zaczynał się od 2000 r., co wykrył test relationships (80 osieroconych
wierszy: 16 województw x lata 1995-1999). Wymiar dat rozszerzono od 1990 r.