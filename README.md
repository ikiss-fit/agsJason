# AGS Jason

Projekt do AGS v Jasonu

Kompilace aStar.java:
```
javac -classpath <path to jason.jar>:. aStar/aStar.java -Xlint:unchecked
javac -classpath ../../../Jason-1.4.2/Jason-1.4.2/lib/jason.jar:. aStar/aStar.java -Xlint:unchecked
```

`-Xlint:unchecked` ignoruje některé warningy (List vs ArrayList)
