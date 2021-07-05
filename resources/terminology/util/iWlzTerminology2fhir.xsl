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
                        <id value="TODO"/>
                        <meta>
                            <profile value="http://hl7.org/fhir/StructureDefinition/shareablecodesystem"/>
                            <!--<profile value="http://hl7.org/fhir/4.0/StructureDefinition/CodeSystem"/>-->
                        </meta>
                        <language value="nl-NL"/>
                        <url value="https://www.istandaarden.nl/ibieb/codesystemen/{$codeSystemCode}"/>
                        <!--<identifier>
                        <use value="official"/>
                        <system value="http://art-decor.org/ns/oids/cs"/>
                        <value value="2.16.840.1.113883.2.4.3.11.[branch codesystemen istandaarden].165"/>
                    </identifier>-->
                        <version value="1.1-20201001"/>
                        <name value="{$codeSystemCode}"/>
                        <title value="{$codeSystemCode}: {$codeSystemName}"/>
                        <status value="active"/>
                        <experimental value="false"/>
                        <publisher value="Zorginstituut Nederland"/>
                        <contact>
                            <name value="iStandaarden of iWlz"/>
                            <telecom>
                                <system value="email"/>
                                <value value="info@istandaarden.nl"/>
                            </telecom>
                        </contact>
                        <description value="{$documentation}"/>
                        <purpose value="This CodeSystem resource represents the the {$codeSystemCode} 'codelijst' as defined by Zorginstituut Nederland. Its contents can be found at https://www.istandaarden.nl/ibieb/codelijsten-iwlz-221 (Excel)."/>
                        <caseSensitive value="false"/>
                        <content value="complete"/>
                        <count value="2"/>
                        <!--<property>
                        <code value="status"/>
                        <uri value="http://hl7.org/fhir/concept-properties"/>
                        <description value="A code that indicates the status of the concept. Values found in this version of the code system are: active, deprecated"/>
                        <type value="code"/>
                    </property>
                    <property>
                        <code value="deprecated"/>
                        <uri value="http://hl7.org/fhir/concept-properties"/>
                        <description value="The date at which a concept was deprecated. Concepts that are deprecated but not inactive can still be used, but their use is discouraged, and they should be expected to be made inactive in a future release. Property type is dateTime. Note that the status property may also be used to indicate that a concept is deprecated"/>
                        <type value="dateTime"/>
                    </property>
                    <property>
                        <code value="effectiveDate"/>
                        <uri value="http://hl7.org/fhir/concept-properties"/>
                        <description value="The date at which the concept was status was last changed. This is calculated based on the highest of 'creation date', 'expiration date', and 'official release date'"/>
                        <type value="dateTime"/>
                    </property>-->
                    </CodeSystem>
                </xsl:result-document>
                <xsl:result-document method="xml" indent="yes" href="{concat($sheetPath,'/../../../../', $codeSystemCode, '-', $codeSystemName, '.xml')}">
                    <ValueSet xmlns="http://hl7.org/fhir">
                        <id value="2.16.840.1.113883.2.4.3.11.[branch valuesets istandaarden].165"/>
                        <meta>
                            <profile value="http://hl7.org/fhir/StructureDefinition/shareablevalueset"/>
                            <!--<profile value="http://hl7.org/fhir/3.0/StructureDefinition/ValueSet"/>-->
                        </meta>
                        <!--<extension url="http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod">
        <valuePeriod>
            <start value="2017-12-31T00:00:00+02:00"/>
        </valuePeriod>
    </extension>-->
                        <url value="http://istandaarden.nl/ibieb/codelijsten/{$codeSystemCode}"/>
                        <!--<identifier>
                            <use value="official"/>
                            <system value="http://art-decor.org/ns/oids/cs"/>
                            <value value="2.16.840.1.113883.2.4.3.11.[branch valuesets istandaarden].165"/>
                        </identifier>-->
                        <!--<version value="2017-12-31T00:00:00"/>-->
                        <name value="{$codeSystemCode}"/>
                        <title value="{$codeSystemCode}: {$codeSystemName}"/>
                        <status value="active"/>
                        <experimental value="false"/>
                        <publisher value="Zorginstituut Nederland"/>
                        <contact>
                            <name value="iStandaarden of iWlz"/>
                            <telecom>
                                <system value="email"/>
                                <value value="info@istandaarden.nl"/>
                            </telecom>
                        </contact>
                        <description value="Indicatie van het soort toewijzing."/>
                        <immutable value="false"/>
                        <purpose value="This ValueSet resource represents the the {$codeSystemCode} 'codelijst' as defined by Zorginstituut Nederland. Its contents can be found at https://www.istandaarden.nl/ibieb/codelijsten-iwlz-221 (Excel)."/>
                        <!--<copyright value="This artefact includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these artefacts must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/getsnomed-ct or info@snomed.org."/>-->
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