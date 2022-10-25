--количество исполнителей в каждом жанре
SELECT GenreID, count(PerformerID) FROM GenrePerformer
GROUP BY GenreID;

--количество треков, вошедших в альбомы 2019-2020 годов
SELECT count(*) FROM Track t
JOIN Album a ON t.AlbumID = a.id
WHERE a.year BETWEEN 2019 and 2020;

--средняя продолжительность треков по каждому альбому
SELECT AlbumID, AVG(duration) FROM Track t
JOIN Album a ON t.AlbumID = a.id
GROUP BY AlbumID
ORDER BY AVG(duration);

--все исполнители, которые не выпустили альбомы в 2020 году
SELECT DISTINCT p.name FROM Performer p
WHERE p.name NOT IN (
	SELECT p.name FROM Performer p
	JOIN PerformerAlbum pa ON p.id = pa.PerformerID
	JOIN Album a ON pa.AlbumID = a.id
	WHERE a.year = 2020);

--названия сборников, в которых присутствует конкретный исполнитель (выберите сами)
SELECT DISTINCT c.name FROM Collection c
JOIN TrackCollection tc ON c.id = tc.CollectionID
JOIN Track t ON tc.TrackID = t.id
JOIN Album a ON t.AlbumID = a.id
JOIN PerformerAlbum pa ON a.id = pa.AlbumID
JOIN Performer p ON pa.PerformerID = p.id
WHERE p.name = 'Louis Armstrong';

--название альбомов, в которых присутствуют исполнители более 1 жанра
SELECT a.name FROM Album a
JOIN PerformerAlbum pa ON a.id = pa.AlbumID
JOIN Performer p ON pa.PerformerID = p.id
JOIN GenrePerformer gp ON p.id = gp.PerformerID
GROUP BY a.name
HAVING COUNT(GenreID) > 1;

--наименование треков, которые не входят в сборники
SELECT t.name FROM Track t
LEFT JOIN TrackCollection tc ON t.id = tc.TrackID
WHERE tc.TrackID IS NULL;

--исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько)
SELECT p.name FROM Performer p
JOIN PerformerAlbum pa ON p.id = pa.PerformerID
JOIN Album a ON pa.AlbumID = a.id
JOIN Track t ON a.id = t.AlbumID
WHERE duration = (SELECT MIN(duration) FROM Track);

--название альбомов, содержащих наименьшее количество треков
SELECT a.name, COUNT(t.name) FROM Album a
JOIN Track t ON a.id = t.AlbumId
GROUP BY a.name
HAVING COUNT(t.name) = (
	SELECT COUNT(t.name) FROM Album a
	JOIN Track t ON a.id = t.AlbumId
	GROUP BY a.name
	ORDER BY COUNT(t.name)
	LIMIT 1);