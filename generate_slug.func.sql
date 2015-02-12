/**
 * generate_slug.func.sql
 *
 * Needs tr.func.sql to work. 
 * Generate slugs from an input string, some cases to remove
 * accents are not covered, I cover only spanish and 
 * portuguese.
 *
 * Copyright (C) 2012 Felipe Alcacibar <falcacibar@gmail.com>
 *
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * version 2 as published by the Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *
 * License available in the following URL
 * http://www.gnu.org/licenses/gpl-2.0.html
 *
**/


DROP FUNCTION IF EXISTS `generate_slug`;

DELIMITER //
CREATE FUNCTION `generate_slug`(`str` VARCHAR(512))
  RETURNS varchar(512)
  LANGUAGE SQL
  NOT DETERMINISTIC
  NO SQL
  SQL SECURITY INVOKER
  COMMENT ''
BEGIN
  SET str = tr(
            tr(
                LOWER(str)
                , 'áàäâãåéèëêíìïîóòöôõúùüûñýçğş'
                , 'aaaaaaeeeeiiiiooooouuuunycgs'
            )
            , '\\#$%&/¿?¡!¬|@~«<{[()]}>»·*+=.,;:ªº^°"''`´‘’”“'
            , NULL
  );

  WHILE str LIKE '%  %' DO
    SET str = REPLACE(str, '  ', ' ');
  END WHILE;

  RETURN REPLACE(
                  REPLACE(
                           str
                          ,'_'
                          ,'-'
                  )
                  , ' '
                  , '-'
  );
END
//

DELIMITER ;
