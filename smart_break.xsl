<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 

<!--
    smart_break
    Breaks long words at weakies (if possible) and inserts a space.

    Long word can break tables. This templates splits word either at default
    (or given weakies) after a given max-length. You can break words with CSS
    (see "word-wrap") when using pixel-units, ems will not work.

    <xsl:call-template name="smart_break">
        <xsl:with-param name="string" select="'Supercalifragilisticexpialidocious'"/>
        <xsl:with-param name="max_length" select="'20'"/>
    </xsl:call-template>
    Returns: Supercalifragilistic expialidocious
-->
<xsl:template name="smart_break">
    <xsl:param name="string"/>
    <xsl:param name="max_length" select="65"/>
    <xsl:param name="weakies" select="'/=_+%-.@'"/>

    <xsl:choose>
        <!--
            if a space is found, print the first part and call this template
            again with the rest of the string for further breaks.
        -->
        <xsl:when test="contains(substring($string, 1, $max_length), ' ')">
            <xsl:value-of select="substring-before($string, ' ')"/>
            <xsl:text> </xsl:text>
            <xsl:call-template name="smart_break">
                <xsl:with-param name="string" select="substring-after($string, ' ')"/>
                <xsl:with-param name="max_length" select="$max_length"/>
                <xsl:with-param name="weakies" select="$weakies"/>
            </xsl:call-template>
        </xsl:when>
        <!-- string length is too long, we have to break it anywhere. -->
        <xsl:when test="string-length($string) &gt; $max_length">
            <!-- find last weakie position in string -->
            <xsl:variable name="weakie_position">
                <xsl:call-template name="weakie_position">
                    <xsl:with-param name="weakies" select="$weakies"/>
                    <xsl:with-param name="string" select="substring($string, 1, $max_length)"/>
                </xsl:call-template>
            </xsl:variable>

            <!--
                actual break position, when no weakie is found, we break at
                max-length.
            -->
            <xsl:variable name="break_position">
                <xsl:choose>
                    <xsl:when test="$weakie_position > 0">
                        <xsl:value-of select="$weakie_position"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$max_length"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:value-of select="substring($string, 1, $break_position)"/>
            <xsl:text> </xsl:text>

            <!-- call smart_break again with the rest of the string -->
            <xsl:call-template name="smart_break">
                <xsl:with-param name="string" select="substring($string, $break_position+1)"/>
                <xsl:with-param name="max_length" select="$max_length"/>
                <xsl:with-param name="weakies" select="$weakies"/>
            </xsl:call-template>
        </xsl:when>

        <!-- string is not long enough for smart breaking. just return it -->
        <xsl:otherwise>
            <xsl:value-of select="$string"/>
        </xsl:otherwise>
    </xsl:choose>

</xsl:template>

<xsl:template name="weakie_position">
    <xsl:param name="string"/>
    <xsl:param name="weakies"/>
    <xsl:param name="position" select="0"/>

    <xsl:variable name="weakie" select="substring($weakies, 1, 1)"/>

    <!--
        loop through all weakies and search for the last position of one single
        weakie.
    -->
    <xsl:choose>
        <!--
            when actual weakie is found in string, we recursively call this
            function again with the rest of the string and check to see if
            this weakie is found again.
        -->
        <xsl:when test="contains($string, $weakie)">
            <xsl:variable name="weakie_position" select="string-length(substring-before($string, $weakie))+1"/>
            <xsl:call-template name="weakie_position">
                <xsl:with-param name="string" select="substring($string, $weakie_position+1)"/>
                <xsl:with-param name="weakies" select="$weakies"/>
                <xsl:with-param name="position" select="$weakie_position"/>
            </xsl:call-template>
        </xsl:when>
        <!--
            when weakie is not found, we move one weakie forward, unless no
            weakies are left.
        -->
        <xsl:when test="not(contains($string, $weakie)) and string-length($weakies) > 1">
            <xsl:call-template name="weakie_position">
                <xsl:with-param name="string" select="$string"/>
                <xsl:with-param name="weakies" select="substring($weakies, 2)"/>
                <xsl:with-param name="position" select="$position"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$position"/>
        </xsl:otherwise>
    </xsl:choose>

</xsl:template>

</xsl:stylesheet>
