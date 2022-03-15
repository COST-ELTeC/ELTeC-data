<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
 exclude-result-prefixes="xs t" version="2.0">
<xsl:output omit-xml-declaration="yes" method="text"/>
 
 <!--believe feel hear know like mean see seem think want-->
 <xsl:param name="verbString">amar conhecer crer desejar duvidar entender julgar pensar querer sentir</xsl:param>
 
 <xsl:template match="/">
  
 <!-- <xsl:message>verbstring: <xsl:value-of select="$verbString"/></xsl:message>
 --> 
  <xsl:variable name="root" select="."/>
  
  <xsl:variable name="dateStr">
   <xsl:choose>
    <xsl:when
     test="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl[@type = 'firstEdition']/t:date">
     <xsl:value-of
      select="normalize-space(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl[@type = 'firstEdition']/t:date)"
     />
    </xsl:when>
    <xsl:when
     test="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl[@type = 'printSource']/t:date">
     <xsl:value-of
      select="normalize-space(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl[@type = 'printSource']/t:date[1])"
     />
    </xsl:when>
    <xsl:when
     test="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl/t:date">
     <xsl:value-of
      select="normalize-space(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl/t:date)"
     />
    </xsl:when>
    <xsl:otherwise>
     <xsl:text>?</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

<xsl:variable name="date">
 <xsl:choose>
  <xsl:when test="contains($dateStr,'-')"><xsl:value-of select="substring-before($dateStr,'-')"/></xsl:when>
  <xsl:otherwise><xsl:value-of select="$dateStr"/></xsl:otherwise>
 </xsl:choose>
</xsl:variable>
  
  <xsl:variable name="textId">
   <xsl:value-of select="/t:TEI/@xml:id"/>
  </xsl:variable>

  <xsl:variable name="verbs">
   <xsl:value-of select="count($root/t:TEI/t:text/t:body//t:w[starts-with(@pos,'VERB')])"/>
  </xsl:variable>

  <!-- output starts here -->
  
<xsl:text>
</xsl:text> <xsl:value-of select="concat($textId,' ', $date,' ', $verbs, ' ')" />
  
<!-- loop around innerverb list  accumulating counts in a string-->
 <xsl:variable name="freqString"> 
  <xsl:for-each select="tokenize($verbString,' ')">
  <xsl:variable name="lem">
    <xsl:value-of select="."/>
   </xsl:variable>
<!--<xsl:message>Counting <xsl:value-of select="$lem"/></xsl:message>
-->   <xsl:variable name="occurs">
      <xsl:value-of select="count($root/t:TEI/t:text/t:body//t:w[starts-with(@pos,'VERB')][t:matching(@lemma, $lem) eq 0])"/>
   </xsl:variable>
   
   <xsl:text> </xsl:text><xsl:value-of select="$occurs+0"/>
 <!--  <xsl:message>Counted <xsl:value-of select="$occurs"/></xsl:message>
-->  </xsl:for-each></xsl:variable>
<xsl:value-of select="sum(for $s in tokenize($freqString, ' ')[string-length(.) gt 0] return number($s))"/><xsl:text> </xsl:text>
<xsl:value-of select="$freqString"/><xsl:text>
</xsl:text>
  </xsl:template>
 
 
 <xsl:function name="t:matching" as="xs:integer">
  <xsl:param name="string1"/>
  <xsl:param name="string2"/>
<xsl:variable name="comparand">
  <xsl:choose> <xsl:when test="contains($string1,'+')">
    <xsl:value-of select="substring-before($string1,'+')"/>
   </xsl:when>
   <xsl:otherwise><xsl:value-of select="$string1"/></xsl:otherwise></xsl:choose>
  </xsl:variable>
  <xsl:value-of select="compare($comparand, $string2)"/>
 </xsl:function>
  
</xsl:stylesheet>
