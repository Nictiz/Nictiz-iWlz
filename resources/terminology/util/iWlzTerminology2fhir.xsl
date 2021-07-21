<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:s="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
    xmlns:nf="http://www.nictiz.nl/functions"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:variable name="sheetPath" select="string-join(tokenize(document-uri(/), '/')[position() lt last()], '/')"/>
    
    <!-- Function to get sharedString from stringId -->
    <xsl:function name="nf:getSharedString">
        <xsl:param name="id" as="xs:double"/>
        
        <xsl:value-of select="document(concat($sheetPath, '/../sharedStrings.xml'))/s:sst/s:si[$id+1]/s:t/text()"/>
    </xsl:function>
    
    <!-- Template should be applied to the relevant sheet[x].xml in *.xlsx/xl/worksheets -->
    <xsl:template match="/">
        <!-- Sheet contains a hidden column A, with the COD-value of the system in it -->
        <xsl:for-each-group select="s:worksheet/s:sheetData/s:row" group-by="s:c[1]/s:v/text()">
            <xsl:variable name="codeSystem" select="translate(nf:getSharedString(number(current-grouping-key())), '/','-')"/>
            <xsl:variable name="codeSystemCode" select="substring-before($codeSystem, ': ')"/>
            <xsl:variable name="codeSystemName" select="substring-after($codeSystem, ': ')"/>
            
            <!-- Account for empty row(s) -->
            <xsl:if test="$codeSystemCode">
                <!-- Get the documentation from the first row of the group -->
                <xsl:variable name="documentationStringId" select="current-group()[1]/s:c[3]/s:v/text()"/>
                <xsl:variable name="documentation" select="nf:getSharedString(number($documentationStringId))"/>
                
                <xsl:result-document method="xml" indent="yes" href="{concat($sheetPath,'/../../../../CodeSystem-', $codeSystemCode, '-', $codeSystemName, '.xml')}">
                    <CodeSystem xmlns="http://hl7.org/fhir">
                        <id value="{$codeSystemCode}-CodeSystem"/>
                        <language value="nl-NL"/>
                        <url value="https://www.istandaarden.nl/ibieb/codesystemen/{$codeSystemCode}"/>
                        <version value="1.1-20201001"/>
                        <name value="{$codeSystemCode}"/>
                        <title value="{$codeSystemCode}: {$codeSystemName}"/>
                        <status value="active"/>
                        <experimental value="false"/>
                        <publisher value="Zorginstituut Nederland"/>
                        <contact>
                            <name value="Zorginstituut Nederland"/>
                            <telecom>
                                <system value="email"/>
                                <value value="info@istandaarden.nl"/>
                            </telecom>
                        </contact>
                        <description value="{$documentation}"/>
                        <purpose value="This CodeSystem resource represents the the {$codeSystemCode} 'codelijst' as defined by Zorginstituut Nederland. Its contents can be found at https://www.istandaarden.nl/ibieb/codelijsten-iwlz-221 (Excel)."/>
                        <caseSensitive value="false"/>
                        <content value="not-present"/>
                    </CodeSystem>
                </xsl:result-document>
                <xsl:result-document method="xml" indent="yes" href="{concat($sheetPath,'/../../../../', $codeSystemCode, '-', $codeSystemName, '.xml')}">
                    <ValueSet xmlns="http://hl7.org/fhir">
                        <id value="{$codeSystemCode}-ValueSet"/>
                        <meta>
                            <profile value="http://hl7.org/fhir/StructureDefinition/shareablevalueset"/>
                        </meta>
                        <url value="http://istandaarden.nl/ibieb/codelijsten/{$codeSystemCode}"/>
                        <version value="1.1-20201001"/>
                        <name value="{$codeSystemCode}"/>
                        <title value="{$codeSystemCode}: {$codeSystemName}"/>
                        <status value="active"/>
                        <experimental value="false"/>
                        <publisher value="Zorginstituut Nederland"/>
                        <contact>
                            <name value="Zorginstituut Nederland"/>
                            <telecom>
                                <system value="email"/>
                                <value value="info@istandaarden.nl"/>
                            </telecom>
                        </contact>
                        <description value="Indicatie van het soort toewijzing."/>
                        <immutable value="false"/>
                        <purpose value="This ValueSet resource represents the the {$codeSystemCode} 'codelijst' as defined by Zorginstituut Nederland. Its contents can be found at https://www.istandaarden.nl/ibieb/codelijsten-iwlz-221 (Excel)."/>
                        <compose>
                            <include>
                                <system value="http://istandaarden.nl/ibieb/codesystemen/{$codeSystemCode}"/>
                                <version value="1.1-20201001"/>
                            </include>
                        </compose>
                    </ValueSet>
                </xsl:result-document>
            </xsl:if>
        </xsl:for-each-group>
    </xsl:template>
    
</xsl:stylesheet>