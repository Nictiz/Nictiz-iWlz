@echo off
:: CHECK BEFORE RUNNING ####
SET jarPath=SaxonHE9-9-1-7J/saxon9he.jar

if not exist "%jarPath%" (
    echo.
    echo.Did not find Saxon JAR here '%jarPath%'. Either add it here, or change the script to supply a different path...
    echo.http://saxon.sourceforge.net
    pause
)


    echo Converting XML
    java -jar "%jarPath%" -s:"../src/Codelijsten iWlz 2.2.1/xl/worksheets/sheet2.xml" -xsl:iWlzTerminology2fhir.xsl
)