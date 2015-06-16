/**
 * strtr.func.sql
 * MySQL UDF implementation of strtr C function, added the
 * functionality to remove characters when dict_to 
 * parameter is NULL
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

DROP FUNCTION IF EXISTS `tr`;

DELIMITER //
CREATE FUNCTION `tr`(`str` TEXT, `dict_from` VARCHAR(1024), `dict_to` VARCHAR(1024))
	RETURNS text
	LANGUAGE SQL
	DETERMINISTIC
	NO SQL
	SQL SECURITY INVOKER
	COMMENT ''
BEGIN
	DECLARE len INTEGER;
	DECLARE i INTEGER;

	IF dict_to IS NOT NULL AND (CHAR_LENGTH(dict_from) != CHAR_LENGTH(dict_to)) THEN
		SET @error = CONCAT('Length of dicts does not match.');
		SIGNAL SQLSTATE '49999'
			SET MESSAGE_TEXT = @error;
	END IF;

	SET len = CHAR_LENGTH(dict_from);
	SET i = 1;

	WHILE len >= i  DO
		SET @f = SUBSTR(dict_from, i, 1);
		SET @t = IF(dict_to IS NULL, '', SUBSTR(dict_to, i, 1));

		SET str = REPLACE(str, @f, @t);
		SET i = i + 1;

	END WHILE;

	RETURN str;
END
//
DELIMITER ;
