<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
                xmlns:ef="http://www.efatura.gov.tr/package-namespace"
                xmlns:inv="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
                xmlns:apr="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"
                xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
                xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
                xmlns:xades="http://uri.etsi.org/01903/v1.3.2#"
                xmlns:hr="http://www.hr-xml.org/3"
                xmlns:oa="http://www.openapplications.org/oagis/9"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                version="1.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
<xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


<!--PROLOG-->


<!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
            <xsl:variable name="p_1" select="1+    count(preceding-sibling::*[name()=name(current())])"/>
            <xsl:if test="$p_1&gt;1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1"/>]</xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>']</xsl:text>
            <xsl:variable name="p_2"
                          select="1+   count(preceding-sibling::*[local-name()=local-name(current())])"/>
            <xsl:if test="$p_2&gt;1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2"/>]</xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters--><xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
<xsl:template match="/">
      <xsl:apply-templates select="/" mode="M0"/>
      <xsl:apply-templates select="/" mode="M1"/>
      <xsl:apply-templates select="/" mode="M20"/>
      <xsl:apply-templates select="/" mode="M21"/>
      <xsl:apply-templates select="/" mode="M30"/>
      <xsl:apply-templates select="/" mode="M31"/>
      <xsl:apply-templates select="/" mode="M32"/>
      <xsl:apply-templates select="/" mode="M33"/>
      <xsl:apply-templates select="/" mode="M34"/>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->


<!--PATTERN codes-->
<xsl:variable name="ProfileIDType" select="',TICARIFATURA,TEMELFATURA,YOLCUBERABERFATURA,'"/>
   <xsl:variable name="InvoiceTypeCodeList"
                 select="',SATIS,IADE,TEVKIFAT,ISTISNA,OZELMATRAH,IHRACKAYITLI,'"/>
   <xsl:variable name="EnvelopeType"
                 select="',SENDERENVELOPE,POSTBOXENVELOPE,SYSTEMENVELOPE,USERENVELOPE,'"/>
   <xsl:variable name="ElementType"
                 select="',INVOICE,APPLICATIONRESPONSE,PROCESSUSERACCOUNT,CANCELUSERACCOUNT,'"/>
   <xsl:variable name="TaxType"
                 select="',0003,0015,0061,0071,0073,0074,0075,0076,0077,1047,1048,4080,4081,9015,9021,9077,8001,8002,8004,8005,8006,8007,8008,9040,0011,4071,4171,'"/>
   <xsl:variable name="WithholdingTaxType"
                 select="',601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,650,'"/>
   <xsl:variable name="WithholdingTaxTypeWithPercent"
                 select="',60120,60290,60350,60450,60550,60690,60790,60890,60950,61090,61190,61270,61370,61450,61550,61650,61750,61850,61950,62050,62190,62290,62350,65090,65050,65070,65020,'"/>
   <xsl:variable name="TaxExemptionReasonCodeType"
                 select="',101,102,103,104,105,106,107,108,151,201,202,204,205,206,207,208,209,211,212,213,214,215,216,217,218,219,220,221,223,225,226,227,228,229,230,231,232,234,235,236,237,238,239,240,250,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,350,351,801,802,803,804,805,806,807,808,809,810,811,701,702,703,'"/>
   <xsl:variable name="istisnaTaxExemptionReasonCodeType"
                 select="',101,102,103,104,105,106,107,108,201,202,204,205,206,207,208,209,211,212,213,214,215,216,217,218,219,220,221,223,225,226,227,228,229,230,231,232,234,235,236,237,238,239,240,250,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,350,'"/>
   <xsl:variable name="ozelMatrahTaxExemptionReasonCodeType"
                 select="',801,802,803,804,805,806,807,808,809,810,811,'"/>
   <xsl:variable name="ihracExemptionReasonCodeType" select="',701,702,703,'"/>
   <xsl:variable name="PartyIdentificationIDType"
                 select="',TCKN,VKN,HIZMETNO,MUSTERINO,TESISATNO,TELEFONNO,DISTRIBUTORNO,TICARETSICILNO,TAPDKNO,BAYINO,ABONENO,SAYACNO,EPDKNO,SUBENO,PASAPORTNO,ARACIKURUMETIKET,ARACIKURUMVKN,CIFTCINO,IMALATCINO,DOSYANO,HASTANO,MERSISNO,URETICINO,'"/>
   <xsl:variable name="ResponseCodeType" select="',KABUL,RED,IADE,S_APR,GUMRUKONAY,'"/>
   <xsl:variable name="AppResponseCodeType"
                 select="',1000,1100,1110,1111,1120,1130,1131,1132,1133,1140,1141,1142,1143,1150,1160,1161,1162,1163,1170,1171,1172,1175,1176,1177,1180,1181,1182,1183,1190,1191,1195,1200,'"/>
   <xsl:variable name="ContactTypeIdentifierType" select="',UNVAN,VKN_TCKN,'"/>
   <xsl:variable name="CurrencyCodeList"
                 select="',AED,AFN,ALL,AMD,ANG,AOA,ARS,AUD,AWG,AZN,BAM,BBD,BDT,BGN,BHD,BIF,BMD,BND,BOB,BOV,BRL,BSD,BTN,BWP,BYR,BZD,CAD,CDF,CHE,CHF,CHW,CLF,CLP,CNY,COP,COU,CRC,CUC,CUP,CVE,CZK,DJF,DKK,DOP,DZD,EEK,EGP,ERN,ETB,EUR,FJD,FKP,GBP,GEL,GHS,GIP,GMD,GNF,GTQ,GWP,GYD,HKD,HNL,HRK,HTG,HUF,IDR,ILS,INR,IQD,IRR,ISK,JMD,JOD,JPY,KES,KGS,KHR,KMF,KPW,KRW,KWD,KYD,KZT,LAK,LBP,LKR,LRD,LSL,LTL,LVL,LYD,MAD,MAD,MDL,MGA,MKD,MMK,MNT,MOP,MRO,MUR,MVR,MWK,MXN,MXV,MYR,MZN,NAD,NGN,NIO,NOK,NPR,NZD,OMR,PAB,PEN,PGK,PHP,PKR,PLN,PYG,QAR,RON,RSD,RUB,RWF,SAR,SBD,SCR,SDG,SEK,SGD,SHP,SLL,SOS,SRD,STD,SVC,SYP,SZL,THB,TJS,TMT,TND,TOP,TRY,TTD,TWD,TZS,UAH,UGX,USD,USN,USS,UYI,UYU,UZS,VEF,VND,VUV,WST,XAF,XAG,XAU,XBA,XBB,XBC,XBD,XCD,XDR,XFU,XOF,XPD,XPF,XPF,XPF,XPT,XTS,XXX,YER,ZAR,ZMK,ZWL,TRL,'"/>
   <xsl:variable name="CountryCodeList"
                 select="',AF,AX,AL,DZ,AS,AD,AO,AI,AQ,AG,AR,AM,AW,AU,AT,AZ,BS,BH,BD,BB,BY,BE,BZ,BJ,BM,BT,BO,BA,BW,BV,BR,IO,BN,BG,BF,BI,KH,CM,CA,CV,KY,CF,TD,CL,CN,CX,CC,CO,KM,CG,CD,CK,CR,CI,HR,CU,CY,CZ,DK,DJ,DM,DO,EC,EG,SV,GQ,ER,EE,ET,FK,FO,FJ,FI,FR,GF,PF,TF,GA,GM,GE,DE,GH,GI,GR,GL,GD,GP,GU,GT,GG,GN,GW,GY,HT,HM,VA,HN,HK,HU,IS,IN,ID,IR,IQ,IE,IM,IL,IT,JM,JP,JE,JO,KZ,KE,KI,KP,KR,KW,KG,LA,LV,LB,LS,LR,LY,LI,LT,LU,MO,MK,MG,MW,MY,MV,ML,MT,MH,MQ,MR,MU,YT,MX,FM,MD,MC,MN,ME,MS,MA,MZ,MM,NA,NR,NP,NL,AN,NC,NZ,NI,NE,NG,NU,NF,MP,NO,OM,PK,PW,PS,PA,PG,PY,PE,PH,PN,PL,PT,PR,QA,RE,RO,RU,RW,BL,SH,KN,LC,MF,PM,VC,WS,SM,ST,SA,SN,RS,SC,SL,SG,SK,SI,SB,SO,ZA,GS,ES,LK,SD,SR,SJ,SZ,SE,CH,SY,TW,TJ,TZ,TH,TL,TG,TK,TO,TT,TN,TR,TM,TC,TV,UG,UA,AE,GB,US,UM,UY,UZ,VU,VE,VN,VG,VI,WF,EH,YE,ZM,ZW,'"/>
   <xsl:variable name="UserType" select="',1,2,11,12,21,22,31,32,41,42,'"/>
   <xsl:variable name="ReservedAliases"
                 select="',usergb,GIB,archive,earchive,archive_earchive,eticket,'"/>
   <xsl:variable name="UnitCodeList"
                 select="',05,06,08,10,11,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,40,41,43,44,45,46,47,48,53,54,56,57,58,59,60,61,62,63,64,66,69,71,72,73,74,76,77,78,80,81,84,2,85,87,89,90,91,92,93,94,95,96,97,98,1A,1B,1C,1D,1E,1F,1G,1H,1I,1J,1K,1L,1M,1X,2A,2B,2C,2G,2H,2I,2J,2K,2L,2M,2N,2P,2Q,2R,2U,2V,2W,2X,2Y,2Z,3B,3C,3E,3G,3H,3I,4A,4B,4C,4E,4G,4H,4K,4L,4M,4N,4O,4P,4Q,4R,4T,4U,4W,4X,5A,5B,5C,5E,5F,5G,5H,5I,5J,5K,5P,5Q,A1,A10,A11,A12,A13,A14,A15,A16,A17,A18,A19,A2,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A3,A30,A31,A32,A33,A34,A35,A36,A37,A38,A39,A4,A40,A41,A42,A43,A44,A45,A47,A48,A49,A5,A50,A51,A52,A53,A54,A55,A56,A57,A58,A59,3.9,A6,A60,A61,A62,A63,A64,A65,A66,A67,A68,A69,A7,A70,A71,A73,A74,A75,A76,A77,A78,A79,A8,A80,A81,A82,A83,A84,A85,A86,A87,A88,A89,A9,A90,A91,A93,A94,A95,A96,A97,A98,A99,AA,AB,ACR,ACT,AD,AE,AH,AI,AJ,AK,AL,AM,AMH,AMP,ANN,2,AP,APZ,AQ,AR,ARE,AS,ASM,ASU,ATM,ATT,AV,AW,AY,AZ,B0,B1,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B2,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B3,B30,B31,B32,B33,B34,B35,B36,B37,B38,B39,B4,B40,B41,B42,B43,B44,B45,B46,B47,B48,B49,B5,B50,B51,B52,B53,B54,B55,B56,B57,B58,B59,B6,B60,B61,B62,B63,B64,B65,B66,B67,B68,B69,B7,B70,B71,B72,B73,B74,B75,B76,B77,B78,B79,B8,B80,B81,B82,B83,B84,B85,B86,B87,B88,B89,B9,B90,B91,B92,B93,B94,B95,B96,B97,B98,B99,BAR,BB,BD,BE,BFT,BG,BH,BHP,BIL,BJ,BK,BL,BLD,BLL,BO,BP,BQL,BR,BT,BTU,BUA,BUI,BW,BX,BZ,C0,C1,C10,C11,C12,C13,C14,C15,C16,C17,C18,C19,C2,C20,C21,C22,C23,C24,C25,C26,C27,C28,C29,C3,C30,C31,C32,C33,C34,C35,C36,C37,C38,C39,C4,C40,C41,C42,C43,C44,C45,C46,C47,C48,C49,C5,C50,C51,C52,C53,C54,C55,C56,C57,C58,C59,C6,C60,C61,C62,C63,C64,C65,C66,C67,C68,C69,C7,C70,C71,C72,C73,C74,C75,C76,C77,C78,C79,C8,C80,C81,C82,C83,C84,C85,C86,C87,C88,C89,C9,C90,C91,C92,C93,C94,C95,C96,C97,C98,C99,CA,CCT,CDL,CEL,CEN,CG,CGM,CH,CJ,CK,CKG,CL,CLF,CLT,CMK,CMQ,CMT,cm,CNP,CNT,CO,COU,CQ,CR,CS,CT,CTG,CTM,CTN,CU,CUR,CV,CWA,CWI,CY,CZ,D03,D04,D1,D10,D11,D12,D13,D14,D15,D16,D17,D18,D19,D2,D20,D21,D22,D23,D24,D25,D26,D27,D28,D29,D30,D31,D32,D33,D34,D35,D36,D37,D38,D39,D40,D41,D42,D43,D44,D45,D46,D47,D48,D49,D5,D50,D51,D52,D53,D54,D55,D56,D57,D58,D59,D6,D60,D61,D62,D63,D64,D65,D66,D67,D68,D69,D7,D70,D71,D72,D73,D74,D75,D76,D77,D78,D79,D8,D80,D81,D82,D83,D85,D86,D87,D88,D89,D9,dyn/cm²,D90,D91,D92,D93,D94,D95,D96,D97,D98,D99,DAA,DAD,DAY,DB,DC,DD,DE,DEC,DG,DI,DJ,DLT,DMA,DMK,DMO,DMQ,DMT,DN,DPC,DPR,DPT,DQ,DR,DRA,DRI,DRL,DRM,DS,DT,DTN,dt or dtn,DU,DWT,DX,DY,DZN,DZP,E01,E07,E08,E09,E10,E11,E12,E14,E15,E16,E17,E18,E19,E2,E20,E21,E22,E23,E25,E27,E28,E3,E30,E31,E32,E33,E34,E35,E36,E37,E38,E39,E4,E40,E41,E42,E43,E44,E45,E46,E47,E48,E49,E5,E50,E51,E52,E53,E54,E55,E56,E57,E58,E59,E60,E61,E62,E63,E64,E65,E66,E67,E68,E69,E70,E71,E72,E73,E74,E75,E76,E77,E78,E79,E80,E81,E82,E83,E84,E85,E86,E87,E88,E89,E90,E91,E92,E93,E94,E95,E96,E97,E98,E99,EA,EB,EC,EP,EQ,EV,F01,F02,F03,F04,F05,F06,F07,F08,F1,F10,F11,F12,F13,F14,F15,F16,F17,F18,F19,F20,F21,F22,F23,F24,F25,F26,F27,F28,F29,F30,F31,F32,F33,F34,F35,F36,F37,F38,F39,F40,F41,F42,F43,F44,F45,F46,F47,F48,F49,F50,F51,F52,F53,F54,F55,F56,F57,F58,F59,F60,F61,F62,F63,F64,F65,F66,F67,F68,F69,F70,F71,F72,F73,F74,F75,F76,F77,F78,F79,F80,F81,F82,F83,F84,F85,F86,F87,F88,F89,F9,F90,F91,F92,F93,F94,F95,F96,F97,F98,F99,FAH,FAR,FB,FBM,FC,FD,FE,FF,FG,FH,FIT,FL,FM,FOT,FP,FR,FS,FTK,FTQ,G01,G04,G05,G06,G08,G09,G10,G11,G12,G13,G14,G15,G16,G17,G18,G19,G2,G20,G21,G23,G24,G25,G26,G27,G28,G29,G3,G30,G31,G32,G33,G34,G35,G36,G37,G38,G39,G40,G41,G42,G43,G44,G45,G46,G47,G48,G49,G50,G51,G52,G53,G54,G55,G56,G57,G58,G59,G60,G61,G62,G63,G64,G65,G66,G67,G68,G69,G7,G70,G71,G72,G73,G74,G75,G76,G77,G78,G79,G80,G81,G82,G83,G84,G85,G86,G87,G88,G89,G90,G91,G92,G93,G94,G95,G96,G97,G98,G99,GB,GBQ,GC,GD,GDW,GE,GF,GFI,GGR,GH,GIA,GIC,GII,GIP,GJ,GK,GL,GLD,GLI,GLL,GM,GN,GO,GP,GQ,GRM,GRN,GRO,GRT,GT,3.1,GV,GW,GWH,GY,GZ,H03,H04,H05,H06,H07,H08,H09,H1,H10,H11,H12,H13,H14,H15,H16,H18,H19,H2,H20,H21,H22,H23,H24,H25,H26,H27,H28,H29,H30,H31,H32,H33,H34,H35,H36,H37,H38,H39,H40,H41,H42,H43,H44,H45,H46,H47,H48,H49,H50,H51,H52,H53,H54,H55,H56,H57,H58,H59,H60,H61,H62,H63,H64,H65,H66,H67,H68,H69,H70,H71,H72,H73,H74,H75,H76,H77,H78,H79,2,H80,H81,H82,H83,H84,H85,H87,H88,H89,H90,H91,H92,H93,H94,H95,H96,H98,H99,HA,HAR,HBA,HBX,HC,HD,HDW,HE,HEA,HF,HGM,HH,HI,HIU,HJ,HK,HKM,HL,HLT,HM,HMQ,HMT,HN,HO,HP,HPA,HS,HT,HTZ,HUR,HY,IA,IC,IE,IF,II,IL,IM,INH,INK,INQ,IP,ISD,IT,IU,IV,J10,J12,J13,J14,J15,J16,J17,J18,J19,J2,J20,J21,J22,J23,J24,J25,J26,J27,J28,J29,J30,J31,J32,J33,J34,J35,J36,J38,J39,J40,J41,J42,J43,J44,J45,J46,J47,J48,J49,J50,J51,J52,J53,J54,J55,J56,J57,J58,J59,J60,J61,J62,J63,J64,J65,J66,J67,J68,J69,J70,J71,J72,J73,J74,J75,J76,J78,J79,J81,J82,J83,J84,J85,J87,J89,J90,J91,J92,J93,J94,J95,J96,J97,J98,J99,JB,JE,JG,JK,JM,JNT,JO,JOU,JPS,JR,JWL,K1,K10,K11,K12,K13,K14,K15,K16,K17,K18,K19,K2,K20,K21,K22,K23,K24,K25,K26,K27,K28,K3,K30,K31,K32,K33,K34,K35,K36,K37,K38,K39,K40,K41,K42,K43,K45,K46,K47,K48,K49,K5,K50,K51,K52,K53,K54,K55,K58,K59,K6,K60,K61,K62,K63,K64,K65,K66,K67,K68,K69,K70,K71,K73,K74,K75,K76,K77,K78,K79,K80,K81,K82,K83,K84,K85,K86,K87,K88,K89,K90,K91,K92,K93,K94,K95,K96,K97,K98,K99,KA,KAT,KB,KBA,KCC,KD,KDW,KEL,KF,KG,KGM,KGS,KHY,KHZ,KI,KIC,KIP,KJ,KJO,KL,KLK,KLX,KMA,KMH,KMK,KMQ,KMT,KNI,KNS,KNT,KO,KPA,KPH,KPO,KPP,KR,KS,KSD,KSH,KT,KTM,KTN,KUR,KVA,KVR,KVT,KW,KWH,KWO,KWT,KX,L10,L11,L12,L13,L14,L15,L16,L17,L18,L19,L2,L20,L21,L23,L24,L25,L26,L27,L28,L29,L30,L31,L32,L33,L34,L35,L36,L37,L38,L39,L40,L41,L42,L43,L44,L45,L46,L47,L48,L49,L50,L51,L52,L53,L54,L55,L56,L57,L58,L59,L60,L61,L62,L63,L64,L65,L66,L67,L68,L69,L70,L71,L72,L73,L74,L75,L76,L77,L78,L79,L80,L81,L82,L83,L84,L85,L86,L87,L88,L89,L90,L91,L92,L93,L94,L95,L96,L98,L99,LA,LAC,LBR,LBT,LC,LD,LE,LEF,LF,LH,LI,LJ,LK,LM,LN,LO,LP,LPA,LR,LS,LTN,LTR,LUB,LUM,LUX,LX,LY,M0,M1,M10,M11,M12,M13,M14,M15,M16,M17,M18,M19,M20,M21,M22,M23,M24,M25,M26,M27,M29,M30,M31,M32,M33,M34,M35,M36,M37,M38,M39,M4,M40,M41,M42,M43,M44,M45,M46,M47,M48,M49,M5,M50,M51,2,M52,M53,M55,M56,M57,M58,M59,M60,M61,M62,M63,M64,M65,M66,M67,M68,M69,M7,M70,M71,M72,M73,M74,M75,M76,M77,M78,M79,M80,M81,M82,M83,M84,M85,M86,M87,M88,M89,M9,M90,M91,M92,M93,M94,M95,M96,M97,M98,M99,MA,MAH,MAL,MAM,MAR,MAW,MBE,MBF,MBR,MC,MCU,MD,MF,MGM,MHZ,MIK,MIL,MIN,MIO,MIU,MK,MLD,MLT,MMK,MMQ,MMT,MND,MON,MPA,MQ,MQH,MQS,MSK,MT,MTK,MTQ,MTR,MTS,MV,MVA,MWH,N1,N10,N11,N12,N13,N14,N15,N16,N17,N18,N19,N2,N20,N21,N22,N23,N24,N25,N26,N27,N28,N29,N3,N30,N31,N32,N33,N34,N35,N36,N37,N38,N39,N40,N41,N42,N43,N44,N45,N46,N47,N48,N49,N50,N51,N52,N53,N54,N55,N56,N57,N58,N59,N60,N61,N62,N63,N64,N65,N66,N67,N68,N69,N70,N71,N72,N73,N74,N75,N76,N77,N78,N79,N80,N81,N82,N83,N84,N85,N86,N87,N88,N89,N90,N91,N92,N93,N94,N95,N96,N97,N98,N99,NA,NAR,NB,NBB,NC,NCL,ND,NE,NEW,NF,NG,NH,NI,NIL,NIU,NJ,NL,NMI,NMP,NN,NPL,NPR,NPT,NQ,NR,NRL,NT,NTT,NU,NV,NX,3.7,NY,OA,ODE,OHM,ON,ONZ,OP,OT,OZ,OZA,OZI,P0,P1,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P2,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P3,P30,P31,P32,P33,P34,P35,P36,P37,P38,P39,P4,P40,P41,P42,P43,P44,P45,P46,P47,P48,P49,P5,P50,P51,P52,P53,P54,P55,P56,P57,P58,P59,P6,P60,P61,P62,P63,P64,P65,P66,P67,P68,P69,P7,P70,P71,P72,P73,P74,P75,P76,P77,P78,P79,P8,P80,P81,P82,P83,P84,P85,P86,P87,P88,P89,P9,P90,P91,P92,P93,P94,P95,P96,P97,P98,P99,PA,PAL,PB,PD,PE,PF,PFL,PG,PGL,PI,PK,3.3,PL,PLA,PM,PN,PO,PQ,PR,PS,PT,PTD,PTI,PTL,PU,PV,PW,PY,PZ,Q10,Q11,Q12,Q13,Q14,Q15,Q16,Q17,Q18,Q19,Q20,Q21,Q22,Q23,Q24,Q25,Q26,Q27,Q28,Q3,QA,QAN,QB,QD,QH,QK,QR,QT,QTD,QTI,QTL,QTR,R1,R4,R9,RA,RD,RG,RH,RK,RL,RM,RN,RO,ROM,RP,RPM,RPS,RS,RT,RU,S3,S4,S5,S6,S7,S8,SA,SAN,SCO,SCR,SD,SE,SEC,SET,SG,SHT,SIE,SK,SL,SMI,SN,SO,SP,SQ,SQR,SR,SS,SST,ST,STC,STI,STK,STL,STN,STW,SV,SW,SX,SYR,T0,T1,T3,T4,T5,T6,T7,T8,TA,TAH,TAN,TC,TD,TE,TF,TI,TIC,TIP,TJ,TK,TKM,TL,TMS,TN,TNE,TP,TPR,TQ,TQD,TR,TRL,TS,TSD,TSH,TST,TT,TTS,TU,TV,TW,TY,U1,U2,UA,UB,UC,UD,UE,UF,UH,UM,VA,VI,VLT,VP,VQ,VS,W2,W4,WA,WB,WCD,WE,WEB,WEE,WG,WH,WHR,WI,WM,WR,WSD,3.5,WTT,WW,X1,YDK,YDQ,YL,YRD,YT,Z1,Z11,Z2,Z3,Z4,Z5,Z6,Z8,ZP,ZZ,'"/>
   <xsl:variable name="PaymentMeansCodeTypeList"
                 select="',1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,60,61,62,63,64,65,66,67,70,74,75,76,77,78,91,92,93,94,95,96,97,ZZZ,'"/>
   <xsl:variable name="ChannelCodeList"
                 select="',AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR,AS,AT,AU,CA,EI,EM,EX,FT,FX,GM,IE,IM,MA,PB,PS,SW,TE,TG,TL,TM,TT,TX,XF,XG,XH,XI,XJ,'"/>
   <xsl:template match="text()" priority="-1" mode="M0"/>
   <xsl:template match="@*|node()" priority="-2" mode="M0">
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

   <!--PATTERN abstracts-->
<xsl:template match="text()" priority="-1" mode="M1"/>
   <xsl:template match="@*|node()" priority="-2" mode="M1">
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M1"/>
   </xsl:template>
   <xsl:param name="envelopeType"
              select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:Type"/>
   <xsl:param name="senderId"
              select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Sender/sh:ContactInformation[sh:ContactTypeIdentifier = 'VKN_TCKN']/sh:Contact"/>
   <xsl:param name="senderAlias"
              select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier"/>
   <xsl:param name="receiverId"
              select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:ContactInformation[sh:ContactTypeIdentifier = 'VKN_TCKN']/sh:Contact"/>
   <xsl:param name="receiverAlias"
              select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier"/>
   <xsl:param name="responseCode"
              select="//apr:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode"/>

   <!--PATTERN document-->


	<!--RULE -->
<xsl:template match="sh:StandardBusinessDocument" priority="1000" mode="M20">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="sh:StandardBusinessDocumentHeader"/>
         <xsl:otherwise>sh:StandardBusinessDocumentHeader zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
	<xsl:choose>
         <xsl:when test="ef:Package"/>
         <xsl:otherwise>ef:Package zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
	  
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>

   <!--PATTERN header-->


	<!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader" priority="1008" mode="M21">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="sh:HeaderVersion = '1.0' or sh:HeaderVersion = '1.2'"/>
         <xsl:otherwise>Geçersiz sh:HeaderVersion elemanı değeri. sh:HeaderVersion elemanı 1.0 veya 1.2 değerine eşit olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(sh:Sender) = 1"/>
         <xsl:otherwise>sh:Sender zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(sh:Receiver) = 1"/>
         <xsl:otherwise>sh:Receiver zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier"
                 priority="1007"
                 mode="M21">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(string(.))) != 0"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri. Boş olmayan bir değer içermelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier"
                 priority="1006"
                 mode="M21">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(string(.))) != 0"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri. Boş olmayan bir değer içermelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader/sh:Sender" priority="1005" mode="M21">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(sh:ContactInformation) &gt; 0"/>
         <xsl:otherwise>En az bir sh:ContactInformation elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(sh:ContactInformation[sh:ContactTypeIdentifier = 'VKN_TCKN']) = 1 "/>
         <xsl:otherwise>sh:ContactTypeIdentifier elemanı değeri 'VKN_TCKN' ye eşit olan bir tane sh:ContactInformation elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader/sh:Receiver" priority="1004"
                 mode="M21">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(sh:ContactInformation) &gt; 0"/>
         <xsl:otherwise>En az bir sh:ContactInformation elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(sh:ContactInformation[sh:ContactTypeIdentifier = 'VKN_TCKN']) = 1 "/>
         <xsl:otherwise>sh:ContactTypeIdentifier elemanı değeri 'VKN_TCKN' ye eşit olan bir tane sh:ContactInformation elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader/sh:Sender/sh:ContactInformation"
                 priority="1003"
                 mode="M21">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="sh:ContactTypeIdentifier"/>
         <xsl:otherwise>sh:ContactTypeIdentifier zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(sh:ContactTypeIdentifier) or contains($ContactTypeIdentifierType, concat(',',sh:ContactTypeIdentifier,','))"/>
         <xsl:otherwise>Geçersiz sh:ContactTypeIdentifier değeri : '<xsl:text/>
            <xsl:value-of select="sh:ContactTypeIdentifier"/>
            <xsl:text/>'. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(sh:ContactTypeIdentifier) or not(sh:ContactTypeIdentifier = 'VKN_TCKN') or string-length(sh:Contact) = 11 or string-length(sh:Contact) = 10"/>
         <xsl:otherwise>sh:ContactTypeIdentifier elemanın değeri 'VKN_TCKN' olması durumunda sh:Contact elemanına 10 haneli vergi kimlik numarası ve ya 11 haneli TC kimlik numarası yazılmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader/sh:Receiver/sh:ContactInformation"
                 priority="1002"
                 mode="M21">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="sh:ContactTypeIdentifier"/>
         <xsl:otherwise>sh:ContactTypeIdentifier zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(sh:ContactTypeIdentifier) or contains($ContactTypeIdentifierType, concat(',',sh:ContactTypeIdentifier,','))"/>
         <xsl:otherwise>Geçersiz sh:ContactTypeIdentifier değeri : '<xsl:text/>
            <xsl:value-of select="sh:ContactTypeIdentifier"/>
            <xsl:text/>'. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(sh:ContactTypeIdentifier) or not(sh:ContactTypeIdentifier = 'VKN_TCKN') or string-length(sh:Contact) = 11 or string-length(sh:Contact) = 10"/>
         <xsl:otherwise>sh:ContactTypeIdentifier elemanın değeri 'VKN_TCKN' olması durumunda sh:Contact elemanına 10 haneli vergi kimlik numarası ve ya 11 haneli TC kimlik numarası yazılmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader/sh:DocumentIdentification"
                 priority="1001"
                 mode="M21">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="sh:TypeVersion = '1.2'"/>
         <xsl:otherwise>Geçersiz sh:TypeVersion elemanı değeri. '1.2' değerine eşit olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($EnvelopeType, concat(',',sh:Type,','))"/>
         <xsl:otherwise>Geçersiz zarf türü : '<xsl:text/>
            <xsl:value-of select="sh:Type"/>
            <xsl:text/>'. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(sh:Type = 'SENDERENVELOPE') or not(//ElementType != 'INVOICE')"/>
         <xsl:otherwise>SENDERENVELOPE türündeki zarf Invoice şemasında göre oluşturulmuş belge taşımalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(sh:Type = 'POSTBOXENVELOPE') or not(//ElementType != 'APPLICATIONRESPONSE')"/>
         <xsl:otherwise>POSTBOXENVELOPE türündeki zarf ApplicationResponse şemasında göre oluşturulmuş belge taşımalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(sh:Type = 'SYSTEMENVELOPE') or not(//ElementType != 'APPLICATIONRESPONSE')"/>
         <xsl:otherwise>SYSTEMENVELOPE türündeki zarf ApplicationResponse şemasına göre oluşturulmuş belge taşımalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(sh:Type = 'USERENVELOPE') or (//ElementType = 'PROCESSUSERACCOUNT' or //ElementType = 'CANCELUSERACCOUNT')"/>
         <xsl:otherwise>USERENVELOPE türündeki zarf ProcessUserAccount ve ya CancelUserAccount şemasına göre oluşturulmuş belge taşımalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(sh:Type = 'USERENVELOPE') or ($receiverId = '3900383669' and $receiverAlias = 'GIB')"/>
         <xsl:otherwise>USERENVELOPE türündeki zarfı yalnızca 3900383669 vergi kimlik numaralı ve GIB etiketli kullanıcıya gönderebilirsiniz.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(sh:Type = 'USERENVELOPE') or ($senderAlias = 'usergb' or $senderAlias = 'archive' or $senderAlias = 'earchive' or $senderAlias = 'archive_earchive' or $senderAlias ='eticket')"/>
         <xsl:otherwise>USERENVELOPE türündeki zarfı yalnızca 'usergb' veya 'archive' veya 'earchive' veya archive_earchive veya eticket etiketine sahip kullanıcı gönderebilir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier"
                 priority="1000"
                 mode="M21">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="matches(.,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri. <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı UUID formatında olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="//cbc:IdentificationCode" priority="1012" mode="M0">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($CountryCodeList, concat(',',.,','))"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri:<xsl:text/>
            <xsl:value-of select="."/>
            <xsl:text/> Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="//cbc:SourceCurrencyCode" priority="1011" mode="M0">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($CurrencyCodeList, concat(',',.,','))"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri:<xsl:text/>
            <xsl:value-of select="."/>
            <xsl:text/> Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="//cbc:TargetCurrencyCode" priority="1010" mode="M0">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($CurrencyCodeList, concat(',',.,','))"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri:<xsl:text/>
            <xsl:value-of select="."/>
            <xsl:text/> Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="//cbc:CurrencyCode" priority="1009" mode="M0">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($CurrencyCodeList, concat(',',.,','))"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri:<xsl:text/>
            <xsl:value-of select="."/>
            <xsl:text/> Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="//@currencyID" priority="1008" mode="M0">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($CurrencyCodeList, concat(',',.,','))"/>
         <xsl:otherwise>Geçersiz currencyID niteliği : '<xsl:text/>
            <xsl:value-of select="."/>
            <xsl:text/>'. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="//@unitCode" priority="1007" mode="M0">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(//cbc:UBLVersionID = '2.1') or contains($UnitCodeList, concat(',',.,','))"/>
         <xsl:otherwise>Geçersiz unitCode niteliği : '<xsl:text/>
            <xsl:value-of select="."/>
            <xsl:text/>'. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="//cbc:ChannelCode" priority="1006" mode="M0">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(//cbc:UBLVersionID = '2.1') or contains($ChannelCodeList, concat(',',.,','))"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri:<xsl:text/>
            <xsl:value-of select="."/>
            <xsl:text/> Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="//cbc:IssueDate" priority="1005" mode="M0">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="xs:date(.) le xs:date(current-date())"/>
         <xsl:otherwise>Geçersiz cbc:IssueDate değeri : '<xsl:text/>
            <xsl:value-of select="."/>
            <xsl:text/>' cbc:IssueDate alanı günün tarihinden ileri bir tarih olamaz<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="xs:date('2005-01-01+02:00')  le xs:date(.)"/>
         <xsl:otherwise>Geçersiz cbc:IssueDate değeri : '<xsl:text/>
            <xsl:value-of select="."/>
            <xsl:text/>' cbc:IssueDate alanı 01.01.2005 tarihinden önce bir tarih olamaz<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

   <!--PATTERN package-->


	<!--RULE -->
<xsl:template match="ef:Package" priority="1001" mode="M30">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(Elements) &lt; 11"/>
         <xsl:otherwise>ef:Package elemanı içerisinde en fazla 10 tane Elements elemanı olabilir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="ef:Package/Elements" priority="1000" mode="M30">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($ElementType, concat(',',ElementType,','))"/>
         <xsl:otherwise>Geçersiz  ElementType değeri : '<xsl:text/>
            <xsl:value-of select="ElementType"/>
            <xsl:text/>'. Geçerli ElementType değerleri için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ElementCount &lt; 1001"/>
         <xsl:otherwise>ElementCount elemanın değeri en fazla 1000 olabilir..<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(ElementList/*) = ElementCount "/>
         <xsl:otherwise>ElementList elemanı içersinde bulunan eleman sayısı ElementCount elemanı değerine eşit olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ElementType='INVOICE') or count(ElementList/inv:Invoice)=ElementCount"/>
         <xsl:otherwise>ElementList elemanı içerisinde bulunan inv:Invoice elemanı sayısı ElementCount elemanı değerine eşit olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ElementType='APPLICATIONRESPONSE') or count(ElementList/apr:ApplicationResponse)=ElementCount"/>
         <xsl:otherwise>ElementList elemanı içerisinde bulunan apr:ApplicationResponse elemanı sayısı ElementCount elemanı değerine eşit olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ElementType='PROCESSUSERACCOUNT') or count(ElementList/hr:ProcessUserAccount)=ElementCount"/>
         <xsl:otherwise>ElementList elemanı içerisinde bulunan hr:ProcessUserAccount elemanı sayısı ElementCount elemanı değerine eşit olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ElementType='CANCELUSERACCOUNT') or count(ElementList/hr:CancelUserAccount)=ElementCount"/>
         <xsl:otherwise>ElementList elemanı içerisinde bulunan hr:CancelUserAccount elemanı sayısı ElementCount elemanı değerine eşit olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ElementType='INVOICE') or count(ElementList/inv:Invoice) &lt; 101 "/>
         <xsl:otherwise>ElementList elemanı içerisinde bulunan inv:Invoice elemanı sayısı 100'den fazla olamaz.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>

   <!--PATTERN invoice-->


	<!--RULE -->
<xsl:template match="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature"
                 priority="1028"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:SignedInfo/ds:Reference/ds:Transforms"/>
         <xsl:otherwise>ds:SignedInfo/ds:Reference/ds:Transforms elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:KeyInfo"/>
         <xsl:otherwise>ds:KeyInfo elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data"/>
         <xsl:otherwise>ds:KeyInfo elemanı içerisindeki ds:X509Data elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:Object"/>
         <xsl:otherwise>ds:Object elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime"/>
         <xsl:otherwise>xades:SigningTime elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate"/>
         <xsl:otherwise>xades:SigningCertificate elemanı zorunlu bir elemandır<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(ds:SignedInfo/ds:Reference[@URI = '']) = 1 "/>
         <xsl:otherwise>ds:SignedInfo elamanı içerisinde URI niteliği boşluğa("") eşit olan sadece bir tane ds:Reference elemanı bulunmaldır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(../../../../cbc:UBLVersionID = '2.1') or ds:SignedInfo/ds:SignatureMethod/@Algorithm !='http://www.w3.org/2000/09/xmldsig#rsa-sha1'"/>
         <xsl:otherwise>ds:SignatureMethod alanının Algorithm niteliği "http://www.w3.org/2000/09/xmldsig#rsa-sha1" olmamalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data"
                 priority="1027"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:X509Certificate"/>
         <xsl:otherwise>ds:X509Data elemanı içerisindeki ds:X509Certificate elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName"
                 priority="1026"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) != 0 "/>
         <xsl:otherwise> ds:X509SubjectName elemanının değeri boşluk olmamalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice" priority="1025" mode="M31">

		<!--ASSERT -->
<xsl:choose>
          <xsl:when test="cbc:UBLVersionID = '2.0' or cbc:UBLVersionID = '2.1'"/>
         <xsl:otherwise>Geçersiz cbc:UBLVersionID elemanı değeri : '<xsl:text/>
            <xsl:value-of select="cbc:UBLVersionID"/>
            <xsl:text/>'. cbc:UBLVersionID değeri '2.1' olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cbc:CustomizationID = 'TR1.0' or cbc:CustomizationID = 'TR1.2'"/>
         <xsl:otherwise>Geçersiz cbc:CustomizationID elemanı değeri : '<xsl:text/>
            <xsl:value-of select="cbc:CustomizationID"/>
            <xsl:text/>' cbc:CustomizationID elemanı değeri 'TR1.2' olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($ProfileIDType, concat(',',cbc:ProfileID,','))"/>
         <xsl:otherwise>Geçersiz cbc:ProfileID elemanı değeri : '<xsl:text/>
            <xsl:value-of select="cbc:ProfileID"/>
            <xsl:text/>'. Geçerli cbc:ProfileID değerleri için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
	  
		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="matches(cbc:ID,'^[A-Z0-9]{3}20[0-9]{2}[0-9]{9}$')"/>
         <xsl:otherwise>Geçersiz cbc:ID elemanı değeri. cbc:ID elemanı 'ABC2009123456789' formatında olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cbc:CopyIndicator = 'false'"/>
         <xsl:otherwise>Geçersiz cbc:CopyIndicator elemanı değeri. cbc:CopyIndicator elemanı 'false' değerine eşit olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($InvoiceTypeCodeList, concat(',',cbc:InvoiceTypeCode,','))"/>
         <xsl:otherwise>Geçersiz cbc:InvoiceTypeCode elemanı değeri : '<xsl:text/>
            <xsl:value-of select="cbc:InvoiceTypeCode"/>
            <xsl:text/>'. Geçerli cbc:InvoiceTypeCode değerleri için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($CurrencyCodeList, concat(',',cbc:DocumentCurrencyCode,','))"/>
         <xsl:otherwise>Geçersiz cbc:DocumentCurrencyCode elemanı değeri. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:TaxCurrencyCode) or contains($CurrencyCodeList, concat(',',cbc:TaxCurrencyCode,','))"/>
         <xsl:otherwise>Geçersiz cbc:TaxCurrencyCode elemanı değeri. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:PricingCurrencyCode) or contains($CurrencyCodeList, concat(',',cbc:PricingCurrencyCode,','))"/>
         <xsl:otherwise>Geçersiz cbc:PricingCurrencyCode elemanı değeri. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:PaymentCurrencyCode) or contains($CurrencyCodeList, concat(',',cbc:PaymentCurrencyCode,','))"/>
         <xsl:otherwise>Geçersiz cbc:PaymentCurrencyCode elemanı değeri. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:PaymentAlternativeCurrencyCode) or contains($CurrencyCodeList, concat(',',cbc:PaymentAlternativeCurrencyCode,','))"/>
         <xsl:otherwise>Geçersiz cbc:PaymentAlternativeCurrencyCode elemanı değeri. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cac:Signature) &lt;= 1"/>
         <xsl:otherwise>En fazla bir tane cac:Signature elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:UBLVersionID ='2.1') or not(exists(cac:WithholdingTaxTotal)) or cbc:InvoiceTypeCode = 'TEVKIFAT' or cbc:InvoiceTypeCode = 'IADE'"/>
         <xsl:otherwise>Uyumsuz fatura tipi: '<xsl:text/>
            <xsl:value-of select="cbc:InvoiceTypeCode"/>
            <xsl:text/>'. cac:WithholdingTaxTotal elamanı varken fatura tipi TEVKIFAT veya IADE olabilir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:UBLVersionID ='2.1') or not(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode[text() = '4171'])) or cbc:InvoiceTypeCode = 'TEVKIFAT' or cbc:InvoiceTypeCode = 'IADE'"/>
         <xsl:otherwise>Uyumsuz fatura tipi: '<xsl:text/>
            <xsl:value-of select="cbc:InvoiceTypeCode"/>
            <xsl:text/>'. cbc:TaxTypeCode değeri 4171 ise fatura tipi TEVKIFAT veya IDAE olabilir<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:UBLVersionID ='2.1') or not(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode[text() = '4171'])) or          exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode[text() = '0071'])"/>
         <xsl:otherwise>cbc:TaxTypeCode değeri 4171 olan cac:TaxSubtotal alanı varken cbc:TaxTypeCode değeri 0071 olan cac:TaxSubtotal alanı da olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cbc:UUID" priority="1024" mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="matches(.,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri. <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı UUID formatında olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:Signature" priority="1023" mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="cbc:ID/@schemeID='VKN_TCKN'"/>
         <xsl:otherwise>cac:Signature elemanı içerisindeki cbc:ID elemanının schemeID niteliği değeri 'VKN_TCKN' olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN_TCKN') or string-length(cbc:ID) = 11 or string-length(cbc:ID) = 10"/>
         <xsl:otherwise>schemeID niteliği 'VKN_TCKN' ye eşit olan elemanın uzunluğu vergi kimlik numarası için 10 karakter TC kimlik numrası için 11 karakter olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:WithholdingTaxTotal/cac:TaxSubtotal" priority="1022"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(normalize-space(string(cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode)))) != 0 and             (string-length(normalize-space(string(cbc:Percent)))) != 0"/>
         <xsl:otherwise>cac:WithholdingTaxTotal elemanı geçerli ve boş değer içermeyen cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode ve cac:TaxSubtotal/cbc:Percent elemanlarına sahip olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($WithholdingTaxType, concat(',',cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode,','))"/>
         <xsl:otherwise>Geçersiz cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode elemanı : '<xsl:text/>
            <xsl:value-of select="cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"/>
            <xsl:text/>'. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($WithholdingTaxTypeWithPercent, concat(',',cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode,cbc:Percent,','))"/>
         <xsl:otherwise> Uyumsuz vergi tipi yüzdesi: '<xsl:text/>
            <xsl:value-of select="cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"/>
            <xsl:text/>' vergi tipinin yüzdesi '<xsl:text/>
            <xsl:value-of select="cbc:Percent"/>
            <xsl:text/>' olamaz <xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID"
                 priority="1021"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))"/>
         <xsl:otherwise>Geçersiz schemeID niteliği : '<xsl:text/>
            <xsl:value-of select="@schemeID"/>
            <xsl:text/>'. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification"
                 priority="1020"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10"/>
         <xsl:otherwise>cbc:ID elemanının schemeID niteliği değeri 'VKN' olması durumunda cbc:ID elemanına 10 haneli vergi kimlik numarası yazılmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11"/>
         <xsl:otherwise>cbc:ID elemanının schemeID niteliği değeri 'TCKN' olması durumunda cbc:ID elemanına 11 haneli TC kimlik numarası yazılmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($senderId) or $senderId = cbc:ID"/>
         <xsl:otherwise>Zarfı gönderen kullanıcı(<xsl:text/>
            <xsl:value-of select="$senderId"/>
            <xsl:text/>) ile faturayı düzenleyen kullanıcı(<xsl:text/>
            <xsl:value-of select="cbc:ID"/>
            <xsl:text/>) aynı olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($senderId) or $senderId = cbc:ID"/>
         <xsl:otherwise>Zarfı gönderen kullanıcı(<xsl:text/>
            <xsl:value-of select="$senderId"/>
            <xsl:text/>) ile faturayı düzenleyen kullanıcı(<xsl:text/>
            <xsl:value-of select="cbc:ID"/>
            <xsl:text/>) aynı olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:AccountingSupplierParty/cac:Party" priority="1019"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1"/>
         <xsl:otherwise>schemeID niteliği değeri 'VKN' ve ya 'TCKN' olan bir tane cbc:ID elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)"/>
         <xsl:otherwise>schemeID niteliği değeri hem 'VKN' hem de 'TCKN' olan cbc:ID elemanları bulunmamalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName"/>
         <xsl:otherwise>schemeID niteliği değeri 'VKN' olması durumunda cac:PartyName elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0"/>
         <xsl:otherwise>cac:PartyName elemanı geçerli ve boş değer içermeyen cbc:Name elemanı içermelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person"/>
         <xsl:otherwise>schemeID niteliği değeri 'TCKN' olması durumunda cac:Person elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0   and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)"/>
         <xsl:otherwise>cac:Person elemanı geçerli ve boş değer içermeyen cbc:FirstName ve cbc:FamilyName elemanlarına sahip olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"
                 priority="1018"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))"/>
         <xsl:otherwise>Geçersiz schemeID niteliği : '<xsl:text/>
            <xsl:value-of select="@schemeID"/>
            <xsl:text/>'. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification"
                 priority="1017"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10"/>
         <xsl:otherwise>cbc:ID elemanının schemeID niteliği değeri 'VKN' olması durumunda cbc:ID elemanına 10 haneli vergi kimlik numarası yazılmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11"/>
         <xsl:otherwise>cbc:ID elemanının schemeID niteliği değeri 'TCKN' olması durumunda cbc:ID elemanına 11 haneli TC kimlik numarası yazılmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($receiverId) or $receiverId = cbc:ID"/>
         <xsl:otherwise>Zarfı alan kullanıcı(<xsl:text/>
            <xsl:value-of select="$receiverId"/>
            <xsl:text/>) ile faturayı alan kullanıcı(<xsl:text/>
            <xsl:value-of select="cbc:ID"/>
            <xsl:text/>) aynı olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($receiverId) or $receiverId = cbc:ID"/>
         <xsl:otherwise>Zarfı alan kullanıcı(<xsl:text/>
            <xsl:value-of select="$receiverId"/>
            <xsl:text/>) ile faturayı alan kullanıcı(<xsl:text/>
            <xsl:value-of select="cbc:ID"/>
            <xsl:text/>) aynı olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:ID ='1460415308') or not(../../../cbc:ProfileID!='YOLCUBERABERFATURA')"/>
         <xsl:otherwise> 1460415308 vergi Numaralı mükellefe (GÜMRÜK VE TİCARET BAKANLIĞI BİLGİ İŞLEMDAİRESİ BAŞKANLIĞI) yollanan fatura senaryosu sadece 'YOLCUBERABERFATURA' olabilir<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:AccountingCustomerParty/cac:Party" priority="1016"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1"/>
         <xsl:otherwise>schemeID niteliği değeri 'VKN' ve ya 'TCKN' olan bir tane cbc:ID elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)"/>
         <xsl:otherwise>schemeID niteliği değeri hem 'VKN' hem de 'TCKN' olan cbc:ID elemanları bulunmamalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName"/>
         <xsl:otherwise>schemeID niteliği değeri 'VKN' olması durumunda cac:PartyName elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0"/>
         <xsl:otherwise>cac:PartyName elemanı geçerli ve boş değer içermeyen cbc:Name elemanı içermelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person"/>
         <xsl:otherwise>schemeID niteliği değeri 'TCKN' olması durumunda cac:Person elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0   and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)"/>
         <xsl:otherwise>cac:Person elemanı geçerli ve boş değer içermeyen cbc:FirstName ve cbc:FamilyName elemanlarına sahip olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"
                 priority="1015"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($TaxType, concat(',',.,','))"/>
         <xsl:otherwise>Geçersiz  cbc:TaxTypeCode değeri : '<xsl:text/>
            <xsl:value-of select="."/>
            <xsl:text/>'. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"
                 priority="1014"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($TaxType, concat(',',.,','))"/>
         <xsl:otherwise>Geçersiz  cbc:TaxTypeCode değeri : '<xsl:text/>
            <xsl:value-of select="."/>
            <xsl:text/>'. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:TaxTotal/cac:TaxSubtotal" priority="1013" mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="../../cbc:InvoiceTypeCode = 'IADE' or ../../cbc:InvoiceTypeCode = 'IHRACKAYITLI' or not(cbc:TaxAmount = 0) or not(cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015') or string-length(normalize-space(cac:TaxCategory/cbc:TaxExemptionReason)) &gt; 0 "/>
         <xsl:otherwise>Vergi miktarı 0 olan 0015 vergi kodlu KDV için cbc:TaxExemptionReason(vergi istisna muhafiyet sebebi) elemanı bulunmalıdır ve boş değer içermemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory"
                 priority="1012"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:TaxExemptionReason) or not(../../../cbc:UBLVersionID ='2.1') or (string-length(normalize-space(string(cbc:TaxExemptionReason)))) &gt; 0"/>
         <xsl:otherwise>cbc:TaxExemptionReason(vergi istisna muhafiyet sebebi) elemanı boş değer içermemelidir<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:TaxExemptionReason) or not(../../../cbc:UBLVersionID ='2.1') or (string-length(normalize-space(string(cbc:TaxExemptionReasonCode)))) != 0 and contains($TaxExemptionReasonCodeType, concat(',',cbc:TaxExemptionReasonCode,','))"/>
         <xsl:otherwise>Geçersiz cbc:TaxExemptionReasonCode niteliği : '<xsl:text/>
            <xsl:value-of select="cbc:TaxExemptionReasonCode"/>
            <xsl:text/>' cbc:TaxExemptionReason(vergi istisna muhafiyet sebebi) elemanı varken cbc:TaxExemptionReasonCode elamanı dolu ve geçerli bir değer olmalıdır. Geçerli değerler için kod listesine bakınız<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(../../../cbc:UBLVersionID ='2.1') or not(contains($istisnaTaxExemptionReasonCodeType, concat(',',cbc:TaxExemptionReasonCode,','))) or ../../../cbc:InvoiceTypeCode = 'ISTISNA' or ../../../cbc:InvoiceTypeCode = 'IADE' or ../../../cbc:InvoiceTypeCode = 'IHRACKAYITLI'"/>
         <xsl:otherwise>Uyumsuz fatura tipi: '<xsl:text/>
            <xsl:value-of select="../../../cbc:InvoiceTypeCode"/>
            <xsl:text/>'. Vergi istisna muhafiyet kodu : '<xsl:text/>
            <xsl:value-of select="cbc:TaxExemptionReasonCode"/>
            <xsl:text/>' için fatura tipi ISTISNA veya IADE veya IHRACKAYITLI olabilir  <xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(../../../cbc:UBLVersionID ='2.1') or not(contains($ozelMatrahTaxExemptionReasonCodeType, concat(',',cbc:TaxExemptionReasonCode,','))) or ../../../cbc:InvoiceTypeCode = 'OZELMATRAH' or ../../../cbc:InvoiceTypeCode = 'IADE'"/>
         <xsl:otherwise>Uyumsuz fatura tipi: '<xsl:text/>
            <xsl:value-of select="../../../cbc:InvoiceTypeCode"/>
            <xsl:text/>'.  Vergi istisna muhafiyet kodu : '<xsl:text/>
            <xsl:value-of select="cbc:TaxExemptionReasonCode"/>
            <xsl:text/>' için fatura tipi OZELMATRAH veya IADE olabilir  <xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(../../../cbc:UBLVersionID ='2.1') or not(contains($ihracExemptionReasonCodeType, concat(',',cbc:TaxExemptionReasonCode,','))) or ../../../cbc:InvoiceTypeCode = 'IHRACKAYITLI' or ../../../cbc:InvoiceTypeCode = 'IADE'"/>
         <xsl:otherwise>Uyumsuz fatura tipi: '<xsl:text/>
            <xsl:value-of select="../../../cbc:InvoiceTypeCode"/>
            <xsl:text/>'.  Vergi istisna muhafiyet kodu : '<xsl:text/>
            <xsl:value-of select="cbc:TaxExemptionReasonCode"/>
            <xsl:text/>' için fatura tipi IHRACKAYITLI veya IADE olabilir  <xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:InvoiceLine/cac:WithholdingTaxTotal/cac:TaxSubtotal"
                 priority="1011"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(normalize-space(string(cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode)))) != 0 and             (string-length(normalize-space(string(cbc:Percent)))) != 0"/>
         <xsl:otherwise>cac:WithholdingTaxTotal elemanı geçerli ve boş değer içermeyen cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode ve cac:TaxSubtotal/cbc:Percent elemanlarına sahip olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($WithholdingTaxType, concat(',',cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode,','))"/>
         <xsl:otherwise>Geçersiz cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode elemanı : '<xsl:text/>
            <xsl:value-of select="cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"/>
            <xsl:text/>'. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($WithholdingTaxTypeWithPercent, concat(',',cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode,cbc:Percent,','))"/>
         <xsl:otherwise> Uyumsuz vergi tipi yüzdesi: '<xsl:text/>
            <xsl:value-of select="cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"/>
            <xsl:text/>' vergi tipinin yüzdesi '<xsl:text/>
            <xsl:value-of select="cbc:Percent"/>
            <xsl:text/>' olamaz <xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:InvoiceLine/cbc:InvoicedQuantity" priority="1010"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(@unitCode)=1"/>
         <xsl:otherwise>cbc:InvoicedQuantity elemanı geçerli ve boş değer içermeyen bir adet unitCode niteliğine sahip olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:LegalMonetaryTotal/cbc:LineExtensionAmount"
                 priority="1009"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri. <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı noktadan önce en fazla 15 , noktadan sonra(kuruş) en fazla 2 haneli olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount"
                 priority="1008"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri. <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı noktadan önce en fazla 15 , noktadan sonra(kuruş) en fazla 2 haneli olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount"
                 priority="1007"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri. <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı noktadan önce en fazla 15 , noktadan sonra(kuruş) en fazla 2 haneli olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount"
                 priority="1006"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri. <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı noktadan önce en fazla 15 , noktadan sonra(kuruş) en fazla 2 haneli olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount" priority="1005"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri. <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı noktadan önce en fazla 15 , noktadan sonra(kuruş) en fazla 2 haneli olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:SignedInfo/ds:Reference/ds:Transforms"
                 priority="1004"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(ds:Transform) &lt;= 1"/>
         <xsl:otherwise>ds:Transforms elemanı içerisinde en fazla bir tane ds:Transform elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:TaxTotal/cbc:TaxAmount" priority="1003" mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri. <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı noktadan önce en fazla 15 , noktadan sonra(kuruş) en fazla 2 haneli olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:Signature/cac:SignatoryParty" priority="1002" mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN']) &gt; 0 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN']) &gt; 0"/>
         <xsl:otherwise>cac:SignatoryParty alanı schemeID niteliği değeri 'VKN' veya 'TCKN' olan en az bir cac:PartyIdentification/cbc:ID elemanı içermelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:TaxTotal/cbc:TaxAmount" priority="1001" mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri. <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı noktadan önce en fazla 15 , noktadan sonra(kuruş) en fazla 2 haneli olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="inv:Invoice/cac:PaymentMeans/cbc:PaymentMeansCode" priority="1000"
                 mode="M31">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(../../cbc:UBLVersionID = '2.1') or contains($PaymentMeansCodeTypeList, concat(',',.,','))"/>
         <xsl:otherwise>Geçersiz  cbc:PaymentMeansCode değeri : '<xsl:text/>
            <xsl:value-of select="."/>
            <xsl:text/>'. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

   <!--PATTERN applicationresponse-->


	<!--RULE -->
<xsl:template match="apr:ApplicationResponse/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature"
                 priority="1015"
                 mode="M32">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:SignedInfo/ds:Reference/ds:Transforms"/>
         <xsl:otherwise>ds:SignedInfo/ds:Reference/ds:Transforms elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:KeyInfo"/>
         <xsl:otherwise>ds:KeyInfo elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data"/>
         <xsl:otherwise>ds:KeyInfo elemanı içerisindeki ds:X509Data elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:Object"/>
         <xsl:otherwise>ds:Object elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime"/>
         <xsl:otherwise>xades:SigningTime elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate"/>
         <xsl:otherwise>xades:SigningCertificate elemanı zorunlu bir elemandır<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="apr:ApplicationResponse/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data"
                 priority="1014"
                 mode="M32">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:X509Certificate"/>
         <xsl:otherwise>ds:X509Data elemanı içerisindeki ds:X509Certificate elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="apr:ApplicationResponse/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName"
                 priority="1013"
                 mode="M32">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) != 0 "/>
         <xsl:otherwise> ds:X509SubjectName elemanının değeri boşluk olmamalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="apr:ApplicationResponse" priority="1012" mode="M32">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="cbc:UBLVersionID = '2.1'"/>
         <xsl:otherwise>Geçersiz cbc:UBLVersionID elemanı değeri : '<xsl:text/>
            <xsl:value-of select="cbc:UBLVersionID"/>
            <xsl:text/>'. cbc:UBLVersionID değeri '2.1' olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cbc:CustomizationID = 'TR1.2'"/>
         <xsl:otherwise>Geçersiz cbc:CustomizationID elemanı değeri : '<xsl:text/>
            <xsl:value-of select="cbc:CustomizationID"/>
            <xsl:text/>' cbc:CustomizationID elemanı değeri 'TR1.2' olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'S_APR') or cbc:ProfileID = 'UBL-TR-PROFILE-1'"/>
         <xsl:otherwise>Sistem yanıtı için cbc:ProfileID  elemanı değeri 'UBL-TR-PROFILE-1' olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or cbc:ProfileID = 'TICARIFATURA'"/>
         <xsl:otherwise>Uygulama yanıtı için cbc:ProfileID  elemanı değeri 'TICARIFATURA' olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(string(cbc:ID))) != 0"/>
         <xsl:otherwise>Geçersiz cbc:ID elemanı değeri. cbc:ID elemanı boş olamaz.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or cac:Signature"/>
         <xsl:otherwise>Uygulama yanıtı için cac:Signature elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or ext:UBLExtensions"/>
         <xsl:otherwise>Uygulama yanıtı için imza bilgisinin konulduğu ext:UBLExtensions elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cac:DocumentResponse) = 1"/>
         <xsl:otherwise>cac:DocumentResponse elemanından bir tane olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cac:Signature) &lt;= 1"/>
         <xsl:otherwise>En fazla bir tane cac:Signature elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:Signature" priority="1011" mode="M32">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="cbc:ID/@schemeID='VKN_TCKN'"/>
         <xsl:otherwise>cac:Signature elemanı içerisindeki cbc:ID elemanının schemeID niteliği değeri 'VKN_TCKN' olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN_TCKN') or string-length(cbc:ID) = 11 or string-length(cbc:ID) = 10"/>
         <xsl:otherwise>schemeID niteliği 'VKN_TCKN' ye eşit olan elemanın uzunluğu vergi kimlik numarası için 10 karakter TC kimlik numrası için 11 karakter olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="apr:ApplicationResponse/cbc:UUID" priority="1010" mode="M32">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="matches(.,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')"/>
         <xsl:otherwise>Geçersiz <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı değeri. <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> elemanı UUID formatında olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:SenderParty/cac:PartyIdentification/cbc:ID"
                 priority="1009"
                 mode="M32">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))"/>
         <xsl:otherwise>Geçersiz schemeID niteliği : '<xsl:text/>
            <xsl:value-of select="@schemeID"/>
            <xsl:text/>'. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:SenderParty/cac:PartyIdentification"
                 priority="1008"
                 mode="M32">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10"/>
         <xsl:otherwise>cbc:ID elemanının schemeID niteliği değeri 'VKN' olması durumunda cbc:ID elemanına 10 haneli vergi kimlik numarası yazılmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11"/>
         <xsl:otherwise>cbc:ID elemanının schemeID niteliği değeri 'TCKN' olması durumunda cbc:ID elemanına 11 haneli TC kimlik numarası yazılmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'S_APR') or not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($senderId) or $senderId = cbc:ID"/>
         <xsl:otherwise>Zarfı gönderen kullanıcı(<xsl:text/>
            <xsl:value-of select="$senderId"/>
            <xsl:text/>) ile sistem yanıtınını düzenleyen kullanıcı(<xsl:text/>
            <xsl:value-of select="cbc:ID"/>
            <xsl:text/>) aynı olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'S_APR') or not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($senderId) or $senderId = cbc:ID"/>
         <xsl:otherwise>Zarfı gönderen kullanıcı(<xsl:text/>
            <xsl:value-of select="$senderId"/>
            <xsl:text/>) ile sistem yanıtınını düzenleyen kullanıcı(<xsl:text/>
            <xsl:value-of select="cbc:ID"/>
            <xsl:text/>) aynı olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($senderId) or $senderId = cbc:ID"/>
         <xsl:otherwise>Zarfı gönderen kullanıcı(<xsl:text/>
            <xsl:value-of select="$senderId"/>
            <xsl:text/>) ile uygulama yanıtınını düzenleyen kullanıcı(<xsl:text/>
            <xsl:value-of select="cbc:ID"/>
            <xsl:text/>) aynı olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($senderId) or $senderId = cbc:ID"/>
         <xsl:otherwise>Zarfı gönderen kullanıcı(<xsl:text/>
            <xsl:value-of select="$senderId"/>
            <xsl:text/>) ile uygulama yanıtınını düzenleyen kullanıcı(<xsl:text/>
            <xsl:value-of select="cbc:ID"/>
            <xsl:text/>) aynı olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:SenderParty" priority="1007" mode="M32">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1"/>
         <xsl:otherwise>schemeID niteliği değeri 'VKN' ve ya 'TCKN' olan bir tane cbc:ID elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)"/>
         <xsl:otherwise>schemeID niteliği değeri hem 'VKN' hem de 'TCKN' olan cbc:ID elemanları bulunmamalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName"/>
         <xsl:otherwise>schemeID niteliği değeri 'VKN' olması durumunda cac:PartyName elemanı bulunmalıdır<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0"/>
         <xsl:otherwise>cac:PartyName elemanı geçerli ve boş değer içermeyen cbc:Name elemanı içermelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person"/>
         <xsl:otherwise>schemeID niteliği değeri 'TCKN' olması durumunda cac:Person elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0   and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)"/>
         <xsl:otherwise>cac:Person elemanı geçerli ve boş değer içermeyen cbc:FirstName ve cbc:FamilyName elemanlarına sahip olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:ReceiverParty/cac:PartyIdentification/cbc:ID"
                 priority="1006"
                 mode="M32">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))"/>
         <xsl:otherwise>Geçersiz schemeID niteliği : '<xsl:text/>
            <xsl:value-of select="@schemeID"/>
            <xsl:text/>'. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:ReceiverParty/cac:PartyIdentification"
                 priority="1005"
                 mode="M32">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10"/>
         <xsl:otherwise>cbc:ID elemanının schemeID niteliği değeri 'VKN' olması durumunda cbc:ID elemanına 10 haneli vergi kimlik numarası yazılmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11"/>
         <xsl:otherwise>cbc:ID elemanının schemeID niteliği değeri 'TCKN' olması durumunda cbc:ID elemanına 11 haneli TC kimlik numarası yazılmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'S_APR') or not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($receiverId) or $receiverId = cbc:ID"/>
         <xsl:otherwise>Zarfı alan kullanıcı(<xsl:text/>
            <xsl:value-of select="$receiverId"/>
            <xsl:text/>) ile sistem yanıtınını alan kullanıcı(<xsl:text/>
            <xsl:value-of select="cbc:ID"/>
            <xsl:text/>) aynı olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'S_APR') or not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($receiverId) or $receiverId = cbc:ID"/>
         <xsl:otherwise>Zarfı alan kullanıcı(<xsl:text/>
            <xsl:value-of select="$receiverId"/>
            <xsl:text/>) ile sistem yanıtınını alan kullanıcı(<xsl:text/>
            <xsl:value-of select="cbc:ID"/>
            <xsl:text/>) aynı olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($receiverId) or $receiverId = cbc:ID"/>
         <xsl:otherwise>Zarfı alan kullanıcı(<xsl:text/>
            <xsl:value-of select="$receiverId"/>
            <xsl:text/>) ile uygulama yanıtınını alan kullanıcı(<xsl:text/>
            <xsl:value-of select="cbc:ID"/>
            <xsl:text/>) aynı olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($receiverId) or $receiverId = cbc:ID"/>
         <xsl:otherwise>Zarfı alan kullanıcı(<xsl:text/>
            <xsl:value-of select="$receiverId"/>
            <xsl:text/>) ile uygulama yanıtınını alan kullanıcı(<xsl:text/>
            <xsl:value-of select="cbc:ID"/>
            <xsl:text/>) aynı olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:ReceiverParty" priority="1004" mode="M32">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1"/>
         <xsl:otherwise>schemeID niteliği değeri 'VKN' ve ya 'TCKN' olan bir tane cbc:ID elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)"/>
         <xsl:otherwise>schemeID niteliği değeri hem 'VKN' hem de 'TCKN' olan cbc:ID elemanları bulunmamalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName"/>
         <xsl:otherwise>schemeID niteliği değeri 'VKN' olması durumunda cac:PartyName elemanı bulunmalıdır<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0"/>
         <xsl:otherwise>cac:PartyName elemanı geçerli ve boş değer içermeyen cbc:Name elemanı içermelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person"/>
         <xsl:otherwise>schemeID niteliği değeri 'TCKN' olması durumunda cac:Person elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'KABUL' or $responseCode = 'RED' or $responseCode = 'IADE') or not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0   and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)"/>
         <xsl:otherwise>cac:Person elemanı geçerli ve boş değer içermeyen cbc:FirstName ve cbc:FamilyName elemanlarına sahip olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:DocumentResponse" priority="1003" mode="M32">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'S_APR') or count(cac:LineResponse) = 1"/>
         <xsl:otherwise>Sistem yanıtı belgesi için cac:LineResponse elemanı zorunludur ve bir tane olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'S_APR') or not(count(cac:LineResponse) = 1) or count(cac:LineResponse/cac:Response) = 1"/>
         <xsl:otherwise>cac:LineResponse elemanı içerisinde bir tane cac:Response elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($responseCode = 'S_APR') or not(count(cac:LineResponse) = 1) or not(count(cac:LineResponse/cac:Response) = 1) or cac:LineResponse/cac:Response/cbc:ResponseCode"/>
         <xsl:otherwise>cac:Response elemanı içerisinde cbc:ResponseCode elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:DocumentResponse/cac:Response"
                 priority="1002"
                 mode="M32">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="cbc:ResponseCode"/>
         <xsl:otherwise>cbc:ResponseCode zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cbc:ResponseCode) or contains($ResponseCodeType, concat(',',cbc:ResponseCode,','))"/>
         <xsl:otherwise>Geçersiz cbc:ResponseCode elemanı değeri '<xsl:text/>
            <xsl:value-of select="cbc:ResponseCode"/>
            <xsl:text/>'. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($envelopeType = 'POSTBOXENVELOPE') or ( cbc:ResponseCode = 'RED' or cbc:ResponseCode = 'KABUL' or cbc:ResponseCode = 'IADE' )"/>
         <xsl:otherwise>POSTBOXENVELOPE türündeki zarfların cbc:ResponseCode değerleri sadece RED,KABUL veya IADE olabilir<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response"
                 priority="1001"
                 mode="M32">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cbc:Description) = 1"/>
         <xsl:otherwise>cac:Response elemanı içerisinde bir tane cbc:Description elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($envelopeType = 'POSTBOXENVELOPE') or ( cbc:ResponseCode = 'RED' or cbc:ResponseCode = 'KABUL' or cbc:ResponseCode = 'IADE' )"/>
         <xsl:otherwise>POSTBOXENVELOPE türündeki zarfların cbc:ResponseCode değerleri sadece RED,KABUL veya IADE olabilir<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($envelopeType = 'SYSTEMENVELOPE') or contains($AppResponseCodeType, concat(',',cbc:ResponseCode,','))"/>
         <xsl:otherwise>SYSTEMENVELOPE türündeki zarflar için geçersiz cbc:ResponseCode elemanı değeri '<xsl:text/>
            <xsl:value-of select="cbc:ResponseCode"/>
            <xsl:text/>'. Geçerli değerler için kod listesine bakınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="apr:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference"
                 priority="1000"
                 mode="M32">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(normalize-space(string(cbc:DocumentTypeCode)))) != 0 "/>
         <xsl:otherwise>cac:DocumentReference elemanı geçerli ve boş değer içermeyen cbc:DocumentTypeCode elemanına sahip olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(normalize-space(string(cbc:DocumentType )))) != 0 "/>
         <xsl:otherwise>cac:DocumentReference elemanı geçerli ve boş değer içermeyen cbc:DocumentType  elemanına sahip olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

   <!--PATTERN processuseraccount-->


	<!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea" priority="1011" mode="M33">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(oa:Sender) = 1 "/>
         <xsl:otherwise>Bir tane oa:Sender elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(oa:Signature) = 1 "/>
         <xsl:otherwise>oa:Signature zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Sender" priority="1010"
                 mode="M33">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="oa:LogicalID"/>
         <xsl:otherwise>oa:LogicalID zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(oa:LogicalID) or (string-length(normalize-space(oa:LogicalID)) = 10 or string-length(normalize-space(oa:LogicalID)) = 11)"/>
         <xsl:otherwise>oa:LogicalID elemanı 10 haneli VKN ve ya 11 haneli TCKN olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(oa:LogicalID) or not(string-length(normalize-space(oa:LogicalID)) = 10 or string-length(normalize-space(oa:LogicalID)) = 11) or not($senderId) or oa:LogicalID = $senderId"/>
         <xsl:otherwise>Zarfı gönderen kullanıcı(<xsl:text/>
            <xsl:value-of select="$senderId"/>
            <xsl:text/>) ile kullanıcı işlemi yapacak özel entegratör(<xsl:text/>
            <xsl:value-of select="oa:LogicalID"/>
            <xsl:text/>) aynı olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature" priority="1009"
                 mode="M33">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(ds:Signature) = 1"/>
         <xsl:otherwise>oa:Signature elemanı içerisinde ds:Signature elemanı zorunludur.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature"
                 priority="1008"
                 mode="M33">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:SignedInfo/ds:Reference/ds:Transforms"/>
         <xsl:otherwise>ds:SignedInfo/ds:Reference/ds:Transforms elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:KeyInfo"/>
         <xsl:otherwise>ds:KeyInfo elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data"/>
         <xsl:otherwise>ds:KeyInfo elemanı içerisindeki ds:X509Data elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:Object"/>
         <xsl:otherwise>ds:Object elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime"/>
         <xsl:otherwise>xades:SigningTime elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate"/>
         <xsl:otherwise>xades:SigningCertificate elemanı zorunlu bir elemandır<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:KeyInfo/ds:X509Data"
                 priority="1007"
                 mode="M33">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:X509Certificate"/>
         <xsl:otherwise>ds:X509Data elemanı içerisindeki ds:X509Certificate elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName"
                 priority="1006"
                 mode="M33">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) != 0 "/>
         <xsl:otherwise> ds:X509SubjectName elemanının değeri boşluk olmamalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature"
                 priority="1005"
                 mode="M33">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(ds:Signature) = 1"/>
         <xsl:otherwise>xades:CounterSignature elemanı içerisinde ds:Signature elemanı zorunludur.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature"
                 priority="1004"
                 mode="M33">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:SignedInfo/ds:Reference/ds:Transforms"/>
         <xsl:otherwise>ds:SignedInfo/ds:Reference/ds:Transforms elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:KeyInfo"/>
         <xsl:otherwise>ds:KeyInfo elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data"/>
         <xsl:otherwise>ds:KeyInfo elemanı içerisindeki ds:X509Data elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:Object"/>
         <xsl:otherwise>ds:Object elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime"/>
         <xsl:otherwise>xades:SigningTime elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate"/>
         <xsl:otherwise>xades:SigningCertificate elemanı zorunlu bir elemandır<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature/ds:KeyInfo/ds:X509Data"
                 priority="1003"
                 mode="M33">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:X509Certificate"/>
         <xsl:otherwise>ds:X509Data elemanı içerisindeki ds:X509Certificate elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:ProcessUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName"
                 priority="1002"
                 mode="M33">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) != 0 "/>
         <xsl:otherwise> ds:X509SubjectName elemanının değeri boşluk olmamalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:ProcessUserAccount/hr:DataArea" priority="1001" mode="M33">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'archive') or count(hr:UserAccount) = 1 "/>
         <xsl:otherwise>Fatura saklama hizmeti için oluşturulan belgelerde yalnızca bir tane hr:UserAccount elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:ProcessUserAccount/hr:DataArea/hr:UserAccount" priority="1000"
                 mode="M33">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(hr:UserID) = 1"/>
         <xsl:otherwise>hr:UserAccount elemanı içersinde hr:UserID zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(hr:PersonName) = 1"/>
         <xsl:otherwise>hr:UserAccount elemanı içersinde hr:PersonName zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'usergb') or count(hr:UserRole) = 1"/>
         <xsl:otherwise>hr:UserAccount elemanı içersinde hr:UserRole zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'archive') or count(hr:UserRole) = 0"/>
         <xsl:otherwise>Fatura saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:UserRole elemanı girilmemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'earchive') or count(hr:UserRole) = 0"/>
         <xsl:otherwise>E-arşiv hizmeti verecekler için hr:UserAccount elemanı içersinde hr:UserRole elemanı girilmemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'archive_earchive') or count(hr:UserRole) = 0"/>
         <xsl:otherwise>E-arşiv saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:UserRole elemanı girilmemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'eticket') or count(hr:UserRole) = 0"/>
         <xsl:otherwise>E-bilet hizmeti verecekler için hr:UserAccount elemanı içersinde hr:UserRole elemanı girilmemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'usergb') or count(hr:AuthorizedWorkScope) = 1"/>
         <xsl:otherwise>hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'archive') or count(hr:AuthorizedWorkScope) = 0"/>
         <xsl:otherwise>Fatura saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'earchive') or count(hr:AuthorizedWorkScope) = 0"/>
         <xsl:otherwise>E-arşiv hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'archive_earchive') or count(hr:AuthorizedWorkScope) = 0"/>
         <xsl:otherwise>E-arşiv saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'eticket') or count(hr:AuthorizedWorkScope) = 0"/>
         <xsl:otherwise>E-bilet hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(hr:AccountConfiguration) = 1"/>
         <xsl:otherwise>hr:UserAccount elemanı içersinde hr:AccountConfiguration zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:UserID) or (string-length(normalize-space(hr:UserID)) = 10 or string-length(normalize-space(hr:UserID)) = 11)"/>
         <xsl:otherwise>hr:UserID elemanına 10 haneli VKN ve ya 11 haneli TCKN yazılmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:UserID) or not(string-length(normalize-space(hr:UserID)) = 10) or not(hr:PersonName) or string-length(hr:PersonName/hr:FormattedName) &gt; 0 "/>
         <xsl:otherwise>Vergi kimlik numarasına sahip kullanıcılar için unvan bilgisi hr:FormattedName elemanına yazılmaldır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:UserID) or not(string-length(normalize-space(hr:UserID)) = 11) or not(hr:PersonName) or (string-length(hr:PersonName/oa:GivenName) &gt; 0 and string-length(hr:PersonName/hr:FamilyName) &gt; 0 )"/>
         <xsl:otherwise>TC kimlik numarasına sahip kullanıcı için ad bilgisi oa:GivenName elemanına ve soyad bilgisi hr:FamilyName elemanına yazılmaldır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count(hr:UserRole) = 1) or hr:UserRole/hr:RoleCode "/>
         <xsl:otherwise>hr:RoleCode zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count(hr:UserRole) = 1) or not(hr:UserRole/hr:RoleCode) or (normalize-space(hr:UserRole/hr:RoleCode) = 'GB' or normalize-space(hr:UserRole/hr:RoleCode) = 'PK')"/>
         <xsl:otherwise>hr:RoleCode elemanı değeri 'GB' ve ya 'PK' olabilir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count(hr:AuthorizedWorkScope) = 1) or string-length(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode)) &gt; 0 "/>
         <xsl:otherwise>hr:WorkScopeCode(etiket) zorunlu bir elemandır ve boş bırakılmamalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count(hr:AuthorizedWorkScope) = 1) or string-length(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode)) &lt;= 250 "/>
         <xsl:otherwise>hr:WorkScopeCode(etiket) zorunlu bir elemandır ve 250 karakterden fazla olmamalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count(hr:AuthorizedWorkScope) = 1) or not(contains($ReservedAliases, concat(',',normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode),','))) "/>
         <xsl:otherwise>hr:WorkScopeCode(etiket) elemanında yasaklı bir etiket kullanmaktasınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count(hr:AuthorizedWorkScope) = 1) or matches(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode),'^urn:[A-Za-z0-9][A-Za-z0-9-]{0,31}:([A-Za-z0-9()+,-.:=@;$_!*]|%[0-9A-Fa-f]{2})+$')"/>
         <xsl:otherwise>Geçersiz hr:WorkScopeCode(etiket) değeri : <xsl:text/>
            <xsl:value-of select="hr:AuthorizedWorkScope/hr:WorkScopeCode"/>
            <xsl:text/>. hr:WorkScopeCode(etiket) zorunlu bir elemandır ve urn formatında olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'usergb') or not(count(hr:AccountConfiguration) = 1) or contains(',1,2,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) "/>
         <xsl:otherwise>hr:UserOptionCode zorunlu bir elemandır ve değeri 1 ve ya 2 olabilir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'archive') or not(count(hr:AccountConfiguration) = 1) or contains(',11,12,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) "/>
         <xsl:otherwise>hr:UserOptionCode zorunlu bir elemandır ve değeri 11 ve ya 12 olabilir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'earchive') or not(count(hr:AccountConfiguration) = 1) or contains(',21,22,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) "/>
         <xsl:otherwise>hr:UserOptionCode zorunlu bir elemandır ve değeri 21 ve ya 22 olabilir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'archive_earchive') or not(count(hr:AccountConfiguration) = 1) or contains(',31,32,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) "/>
         <xsl:otherwise>hr:UserOptionCode zorunlu bir elemandır ve değeri 31 ve ya 32 olabilir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'eticket') or not(count(hr:AccountConfiguration) = 1) or contains(',41,42,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) "/>
         <xsl:otherwise>hr:UserOptionCode zorunlu bir elemandır ve değeri 41 ve ya 42 olabilir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:UserID) or not(following-sibling::hr:UserAccount) or  normalize-space(hr:UserID) = following-sibling::node()/normalize-space(hr:UserID)"/>
         <xsl:otherwise>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:UserID'ye ait işlem yapılmalıdır. Farklı iki hr:UserID(<xsl:text/>
            <xsl:value-of select="hr:UserID"/>
            <xsl:text/>, <xsl:text/>
            <xsl:value-of select="following::node()/hr:UserID"/>
            <xsl:text/>) bulundu. <xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:PersonName) or not(hr:PersonName/hr:FormattedName) or not(following-sibling::hr:UserAccount) or  hr:PersonName/normalize-space(hr:FormattedName) = following::node()/hr:PersonName/normalize-space(hr:FormattedName)"/>
         <xsl:otherwise>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:FormattedName'e ait işlem yapılmalıdır. Farklı iki hr:FormattedName(<xsl:text/>
            <xsl:value-of select="hr:PersonName/hr:FormattedName"/>
            <xsl:text/>, <xsl:text/>
            <xsl:value-of select="following-sibling::node()/hr:PersonName/hr:FormattedName"/>
            <xsl:text/>) bulundu.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:PersonName) or not(hr:PersonName/oa:GivenName)     or not(following-sibling::hr:UserAccount) or  hr:PersonName/normalize-space(oa:GivenName)     = following::node()/hr:PersonName/normalize-space(oa:GivenName)"/>
         <xsl:otherwise>ProcessUserAccount ve CancelUserAccount belgesinde aynı oa:GivenName'e ait işlem yapılmalıdır. Farklı iki oa:GivenName(<xsl:text/>
            <xsl:value-of select="hr:PersonName/oa:GivenName"/>
            <xsl:text/>, <xsl:text/>
            <xsl:value-of select="following::node()/hr:PersonName/oa:GivenName"/>
            <xsl:text/>) bulundu.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:PersonName) or not(hr:PersonName/hr:MiddleName)    or not(following-sibling::hr:UserAccount) or  hr:PersonName/normalize-space(hr:MiddleName)    = following::node()/hr:PersonName/normalize-space(hr:MiddleName)"/>
         <xsl:otherwise>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:MiddleName'e ait işlem yapılmalıdır. Farklı iki hr:MiddleName(<xsl:text/>
            <xsl:value-of select="hr:PersonName/hr:MiddleName"/>
            <xsl:text/>, <xsl:text/>
            <xsl:value-of select="following::node()/hr:PersonName/hr:MiddleName"/>
            <xsl:text/>) bulundu.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:PersonName) or not(hr:PersonName/hr:FamilyName)    or not(following-sibling::hr:UserAccount) or  hr:PersonName/normalize-space(hr:FamilyName)    = following::node()/hr:PersonName/normalize-space(hr:FamilyName)"/>
         <xsl:otherwise>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:FamilyName'e ait işlem yapılmalıdır. Farklı iki hr:FamilyName(<xsl:text/>
            <xsl:value-of select="hr:PersonName/hr:FamilyName"/>
            <xsl:text/>, <xsl:text/>
            <xsl:value-of select="following::node()/hr:PersonName/hr:FamilyName"/>
            <xsl:text/>) bulundu.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:AccountConfiguration) or not(hr:AccountConfiguration/hr:UserOptionCode) or not(following-sibling::hr:UserAccount) or  hr:AccountConfiguration/normalize-space(hr:UserOptionCode) = following::node()/hr:AccountConfiguration/normalize-space(hr:UserOptionCode)"/>
         <xsl:otherwise>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:UserOptionCode'e ait işlem yapılmalıdır. Farklı iki hr:UserOptionCode(<xsl:text/>
            <xsl:value-of select="hr:AccountConfiguration/hr:UserOptionCode"/>
            <xsl:text/>, <xsl:text/>
            <xsl:value-of select="following::node()/hr:AccountConfiguration/hr:UserOptionCode"/>
            <xsl:text/>) bulundu.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

   <!--PATTERN canceluseraccount-->


	<!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea" priority="1011" mode="M34">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(oa:Sender) = 1 "/>
         <xsl:otherwise>Bir tane oa:Sender elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(oa:Signature) = 1 "/>
         <xsl:otherwise>oa:Signature zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Sender" priority="1010"
                 mode="M34">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="oa:LogicalID"/>
         <xsl:otherwise>oa:LogicalID zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(oa:LogicalID) or (string-length(normalize-space(oa:LogicalID)) = 10 or string-length(normalize-space(oa:LogicalID)) = 11)"/>
         <xsl:otherwise>oa:LogicalID elemanı 10 haneli VKN ve ya 11 haneli TCKN olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(oa:LogicalID) or not(string-length(normalize-space(oa:LogicalID)) = 10 or string-length(normalize-space(oa:LogicalID)) = 11) or not($senderId) or oa:LogicalID = $senderId"/>
         <xsl:otherwise>Zarfı gönderen kullanıcı(<xsl:text/>
            <xsl:value-of select="$senderId"/>
            <xsl:text/>) ile kullanıcı işlemi yapacak özel entegratör(<xsl:text/>
            <xsl:value-of select="oa:LogicalID"/>
            <xsl:text/>) aynı olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature" priority="1009"
                 mode="M34">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(ds:Signature) = 1"/>
         <xsl:otherwise>oa:Signature elemanı içerisinde ds:Signature elemanı zorunludur.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature"
                 priority="1008"
                 mode="M34">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:SignedInfo/ds:Reference/ds:Transforms"/>
         <xsl:otherwise>ds:SignedInfo/ds:Reference/ds:Transforms elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:KeyInfo"/>
         <xsl:otherwise>ds:KeyInfo elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data"/>
         <xsl:otherwise>ds:KeyInfo elemanı içerisindeki ds:X509Data elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:Object"/>
         <xsl:otherwise>ds:Object elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime"/>
         <xsl:otherwise>xades:SigningTime elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate"/>
         <xsl:otherwise>xades:SigningCertificate elemanı zorunlu bir elemandır<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:KeyInfo/ds:X509Data"
                 priority="1007"
                 mode="M34">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:X509Certificate"/>
         <xsl:otherwise>ds:X509Data elemanı içerisindeki ds:X509Certificate elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName"
                 priority="1006"
                 mode="M34">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) != 0 "/>
         <xsl:otherwise> ds:X509SubjectName elemanının değeri boşluk olmamalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature"
                 priority="1005"
                 mode="M34">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(ds:Signature) = 1"/>
         <xsl:otherwise>xades:CounterSignature elemanı içerisinde ds:Signature elemanı zorunludur.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature"
                 priority="1004"
                 mode="M34">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:SignedInfo/ds:Reference/ds:Transforms"/>
         <xsl:otherwise>ds:SignedInfo/ds:Reference/ds:Transforms elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:KeyInfo"/>
         <xsl:otherwise>ds:KeyInfo elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data"/>
         <xsl:otherwise>ds:KeyInfo elemanı içerisindeki ds:X509Data elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:Object"/>
         <xsl:otherwise>ds:Object elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime"/>
         <xsl:otherwise>xades:SigningTime elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate"/>
         <xsl:otherwise>xades:SigningCertificate elemanı zorunlu bir elemandır<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature/ds:KeyInfo/ds:X509Data"
                 priority="1003"
                 mode="M34">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="ds:X509Certificate"/>
         <xsl:otherwise>ds:X509Data elemanı içerisindeki ds:X509Certificate elemanı zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:CancelUserAccount/oa:ApplicationArea/oa:Signature/ds:Signature/ds:Object/xades:QualifyingProperties/xades:UnsignedProperties/xades:UnsignedSignatureProperties/xades:CounterSignature/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName"
                 priority="1002"
                 mode="M34">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) != 0 "/>
         <xsl:otherwise> ds:X509SubjectName elemanının değeri boşluk olmamalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:CancelUserAccount/hr:DataArea" priority="1001" mode="M34">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'archive') or count(hr:UserAccount) = 1 "/>
         <xsl:otherwise>Fatura saklama hizmeti için oluşturulan belgelerde yalnızca bir tane hr:UserAccount elemanı bulunmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="hr:CancelUserAccount/hr:DataArea/hr:UserAccount" priority="1000"
                 mode="M34">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(hr:UserID) = 1"/>
         <xsl:otherwise>hr:UserAccount elemanı içersinde hr:UserID zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(hr:PersonName) = 1"/>
         <xsl:otherwise>hr:UserAccount elemanı içersinde hr:PersonName zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'usergb') or count(hr:UserRole) = 1"/>
         <xsl:otherwise>hr:UserAccount elemanı içersinde hr:UserRole zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'archive') or count(hr:UserRole) = 0"/>
         <xsl:otherwise>Fatura saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:UserRole elemanı girilmemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'earchive') or count(hr:UserRole) = 0"/>
         <xsl:otherwise>E-arşiv hizmeti verecekler için hr:UserAccount elemanı içersinde hr:UserRole elemanı girilmemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'archive_earchive') or count(hr:UserRole) = 0"/>
         <xsl:otherwise>E-arşiv saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:UserRole elemanı girilmemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'eticket') or count(hr:UserRole) = 0"/>
         <xsl:otherwise>E-bilet hizmeti verecekler için hr:UserAccount elemanı içersinde hr:UserRole elemanı girilmemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'usergb') or count(hr:AuthorizedWorkScope) = 1"/>
         <xsl:otherwise>hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'archive') or count(hr:AuthorizedWorkScope) = 0"/>
         <xsl:otherwise>Fatura saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'earchive') or count(hr:AuthorizedWorkScope) = 0"/>
         <xsl:otherwise>E-arşiv hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'archive_earchive') or count(hr:AuthorizedWorkScope) = 0"/>
         <xsl:otherwise>E-arşiv saklama hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'eticket') or count(hr:AuthorizedWorkScope) = 0"/>
         <xsl:otherwise>E-bilet hizmeti verecekler için hr:UserAccount elemanı içersinde hr:AuthorizedWorkScope elemanı girilmemelidir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(hr:AccountConfiguration) = 1"/>
         <xsl:otherwise>hr:UserAccount elemanı içersinde hr:AccountConfiguration zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:UserID) or (string-length(normalize-space(hr:UserID)) = 10 or string-length(normalize-space(hr:UserID)) = 11)"/>
         <xsl:otherwise>hr:UserID elemanına 10 haneli VKN ve ya 11 haneli TCKN yazılmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:UserID) or not(string-length(normalize-space(hr:UserID)) = 10) or not(hr:PersonName) or string-length(hr:PersonName/hr:FormattedName) &gt; 0 "/>
         <xsl:otherwise>Vergi kimlik numarasına sahip kullanıcılar için unvan bilgisi hr:FormattedName elemanına yazılmaldır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:UserID) or not(string-length(normalize-space(hr:UserID)) = 11) or not(hr:PersonName) or (string-length(hr:PersonName/oa:GivenName) &gt; 0 and string-length(hr:PersonName/hr:FamilyName) &gt; 0 )"/>
         <xsl:otherwise>TC kimlik numarasına sahip kullanıcı için ad bilgisi oa:GivenName elemanına ve soyad bilgisi hr:FamilyName elemanına yazılmaldır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count(hr:UserRole) = 1) or hr:UserRole/hr:RoleCode "/>
         <xsl:otherwise>hr:RoleCode zorunlu bir elemandır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count(hr:UserRole) = 1) or not(hr:UserRole/hr:RoleCode) or (normalize-space(hr:UserRole/hr:RoleCode) = 'GB' or normalize-space(hr:UserRole/hr:RoleCode) = 'PK')"/>
         <xsl:otherwise>hr:RoleCode elemanı değeri 'GB' ve ya 'PK' olabilir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count(hr:AuthorizedWorkScope) = 1) or string-length(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode)) &gt; 0 "/>
         <xsl:otherwise>hr:WorkScopeCode(etiket) zorunlu bir elemandır ve boş bırakılmamalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count(hr:AuthorizedWorkScope) = 1) or string-length(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode)) &lt;= 250 "/>
         <xsl:otherwise>hr:WorkScopeCode(etiket) zorunlu bir elemandır ve 250 karakterden fazla olmamalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count(hr:AuthorizedWorkScope) = 1) or not(contains($ReservedAliases, concat(',',normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode),','))) "/>
         <xsl:otherwise>hr:WorkScopeCode(etiket) elemanında yasaklı bir etiket kullanmaktasınız.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(count(hr:AuthorizedWorkScope) = 1) or matches(normalize-space(hr:AuthorizedWorkScope/hr:WorkScopeCode),'^urn:[A-Za-z0-9][A-Za-z0-9-]{0,31}:([A-Za-z0-9()+,-.:=@;$_!*]|%[0-9A-Fa-f]{2})+$')"/>
         <xsl:otherwise>Geçersiz hr:WorkScopeCode(etiket) değeri : <xsl:text/>
            <xsl:value-of select="hr:AuthorizedWorkScope/hr:WorkScopeCode"/>
            <xsl:text/>. hr:WorkScopeCode(etiket) zorunlu bir elemandır ve urn formatında olmalıdır.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'usergb') or not(count(hr:AccountConfiguration) = 1) or contains(',1,2,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) "/>
         <xsl:otherwise>hr:UserOptionCode zorunlu bir elemandır ve değeri 1 ve ya 2 olabilir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'archive') or not(count(hr:AccountConfiguration) = 1) or contains(',11,12,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) "/>
         <xsl:otherwise>hr:UserOptionCode zorunlu bir elemandır ve değeri 11 ve ya 12 olabilir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'earchive') or not(count(hr:AccountConfiguration) = 1) or contains(',21,22,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) "/>
         <xsl:otherwise>hr:UserOptionCode zorunlu bir elemandır ve değeri 21 ve ya 22 olabilir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'archive_earchive') or not(count(hr:AccountConfiguration) = 1) or contains(',31,32,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) "/>
         <xsl:otherwise>hr:UserOptionCode zorunlu bir elemandır ve değeri 31 ve ya 32 olabilir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($senderAlias = 'eticket') or not(count(hr:AccountConfiguration) = 1) or contains(',41,42,', concat(',',hr:AccountConfiguration/hr:UserOptionCode,',')) "/>
         <xsl:otherwise>hr:UserOptionCode zorunlu bir elemandır ve değeri 41 ve ya 42 olabilir.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:UserID) or not(following-sibling::hr:UserAccount) or  normalize-space(hr:UserID) = following-sibling::node()/normalize-space(hr:UserID)"/>
         <xsl:otherwise>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:UserID'ye ait işlem yapılmalıdır. Farklı iki hr:UserID(<xsl:text/>
            <xsl:value-of select="hr:UserID"/>
            <xsl:text/>, <xsl:text/>
            <xsl:value-of select="following::node()/hr:UserID"/>
            <xsl:text/>) bulundu. <xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:PersonName) or not(hr:PersonName/hr:FormattedName) or not(following-sibling::hr:UserAccount) or  hr:PersonName/normalize-space(hr:FormattedName) = following::node()/hr:PersonName/normalize-space(hr:FormattedName)"/>
         <xsl:otherwise>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:FormattedName'e ait işlem yapılmalıdır. Farklı iki hr:FormattedName(<xsl:text/>
            <xsl:value-of select="hr:PersonName/hr:FormattedName"/>
            <xsl:text/>, <xsl:text/>
            <xsl:value-of select="following-sibling::node()/hr:PersonName/hr:FormattedName"/>
            <xsl:text/>) bulundu.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:PersonName) or not(hr:PersonName/oa:GivenName)     or not(following-sibling::hr:UserAccount) or  hr:PersonName/normalize-space(oa:GivenName)     = following::node()/hr:PersonName/normalize-space(oa:GivenName)"/>
         <xsl:otherwise>ProcessUserAccount ve CancelUserAccount belgesinde aynı oa:GivenName'e ait işlem yapılmalıdır. Farklı iki oa:GivenName(<xsl:text/>
            <xsl:value-of select="hr:PersonName/oa:GivenName"/>
            <xsl:text/>, <xsl:text/>
            <xsl:value-of select="following::node()/hr:PersonName/oa:GivenName"/>
            <xsl:text/>) bulundu.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:PersonName) or not(hr:PersonName/hr:MiddleName)    or not(following-sibling::hr:UserAccount) or  hr:PersonName/normalize-space(hr:MiddleName)    = following::node()/hr:PersonName/normalize-space(hr:MiddleName)"/>
         <xsl:otherwise>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:MiddleName'e ait işlem yapılmalıdır. Farklı iki hr:MiddleName(<xsl:text/>
            <xsl:value-of select="hr:PersonName/hr:MiddleName"/>
            <xsl:text/>, <xsl:text/>
            <xsl:value-of select="following::node()/hr:PersonName/hr:MiddleName"/>
            <xsl:text/>) bulundu.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:PersonName) or not(hr:PersonName/hr:FamilyName)    or not(following-sibling::hr:UserAccount) or  hr:PersonName/normalize-space(hr:FamilyName)    = following::node()/hr:PersonName/normalize-space(hr:FamilyName)"/>
         <xsl:otherwise>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:FamilyName'e ait işlem yapılmalıdır. Farklı iki hr:FamilyName(<xsl:text/>
            <xsl:value-of select="hr:PersonName/hr:FamilyName"/>
            <xsl:text/>, <xsl:text/>
            <xsl:value-of select="following::node()/hr:PersonName/hr:FamilyName"/>
            <xsl:text/>) bulundu.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(hr:AccountConfiguration) or not(hr:AccountConfiguration/hr:UserOptionCode) or not(following-sibling::hr:UserAccount) or  hr:AccountConfiguration/normalize-space(hr:UserOptionCode) = following::node()/hr:AccountConfiguration/normalize-space(hr:UserOptionCode)"/>
         <xsl:otherwise>ProcessUserAccount ve CancelUserAccount belgesinde aynı hr:UserOptionCode'e ait işlem yapılmalıdır. Farklı iki hr:UserOptionCode(<xsl:text/>
            <xsl:value-of select="hr:AccountConfiguration/hr:UserOptionCode"/>
            <xsl:text/>, <xsl:text/>
            <xsl:value-of select="following::node()/hr:AccountConfiguration/hr:UserOptionCode"/>
            <xsl:text/>) bulundu.<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>
</xsl:stylesheet>