## Description

Complète la couverture temporelle lorsque l'intervalle est incomplet.


## Paramètres

Aucun.


## Prérequis

Aucun.


## Motivation

La spécification indique qu'un intervalle `gml:TimePeriod` doit contenir une borne de début *et* une borne de fin.


## Exemples

Lorsque `gml:TimePeriod` ne contient pas de borne de début :

    <gmd:EX_TemporalExtent>
      <gmd:extent>
        <gml:TimePeriod>
          <gml:beginPosition>2021-05-21</gml:beginPosition>
          <!-- début de l'ajout -->
          <gml:endPosition indeterminatePosition="unknown"/>
          <!-- fin de l'ajout -->
        </gml:TimePeriod>
      </gmd:extent>
    </gmd:EX_TemporalExtent>

Lorsque `gml:TimePeriod` ne contient pas de borne de fin :

    <gmd:EX_TemporalExtent>
      <gmd:extent>
        <gml:TimePeriod>
          <!-- début de l'ajout -->
          <gml:beginPosition indeterminatePosition="unknown"/>
          <!-- fin de l'ajout -->
          <gml:endPosition>2021-05-21</gml:beginPosition>
        </gml:TimePeriod>
      </gmd:extent>
    </gmd:EX_TemporalExtent>


## Références

TODO
