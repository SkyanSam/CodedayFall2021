using Godot;
using System;
using System.Collections.Generic;

public class Tilemap : Node
{
	List<PackedScene> preloadedBlocks;
	Random random;
	int[][] tilemap;
	Spatial[][] blockmap;
	List<int[][]> rooms;

	[Export]
	string[] blocks;
	[Export]
	int diameter = 100;
	[Export]
	public int minRoomDistance = 2;
	[Export]
	public int minHallwayTurns = 1;
	[Export]
	public int maxHallwayTurns = 3;
	[Export]
	public int minHallwaySegmentLength = 5;
	[Export]
	public int maxHallwaySegmentLength = 20;
	[Export]
	public int iterations = 100;
	[Export]
	public int tries = 100;
	public override void _Ready()
	{
		random = new Random();
		tilemap = new int[diameter][];
		for (int y = 0; y < diameter; y++)
		{
			tilemap[y] = new int[diameter];
			for (int x = 0; x < diameter; x++)
				tilemap[y][x] = -1;
		}
			
		blockmap = new Spatial[diameter][];

		Load();
		InitRooms();
		Procedural();
		Render();
	}
	public void InitRooms()
	{
		var room1 = new int[5][];
		room1[0] = new int[] { 1, 1, 1, 1, 1 };
		room1[1] = new int[] { 1, 0, 0, 0, 1 };
		room1[2] = new int[] { 1, 0, 0, 0, 10 };
		room1[3] = new int[] { 1, 0, 0, 0, 1 };
		room1[4] = new int[] { 1, 1, 10, 1, 1 };
		
		var room2 = new int[5][];
		room2[0] = new int[] { 1, 1, 1, 1, 1 };
		room2[1] = new int[] { 1, 0, 0, 0, 1 };
		room2[2] = new int[] { 10, 0, 0, 0, 1 };
		room2[3] = new int[] { 1, 0, 0, 0, 1 };
		room2[4] = new int[] { 1, 1, 10, 1, 1 };

		var room3 = new int[5][];
		room3[0] = new int[] { 1, 1, 10, 1, 1 };
		room3[1] = new int[] { 1, 0, 0, 0, 1 };
		room3[2] = new int[] { 1, 0, 0, 0, 10 };
		room3[3] = new int[] { 1, 0, 0, 0, 1 };
		room3[4] = new int[] { 1, 1, 1, 1, 1 };

		List<int[][]> rooms = new List<int[][]>();
		rooms.Add(room1);
		rooms.Add(room2);
		rooms.Add(room3);
	}
	public void Load()
	{
		preloadedBlocks = new List<PackedScene>();
		foreach (var b in blocks)
			preloadedBlocks.Add((PackedScene)ResourceLoader.Load(b));
	}
	public void Render()
	{
		for (int y = 0; y < diameter; y++)
		{
			string printLn = "";
			for (int x = 0; x < diameter; x++)
			{
				if (tilemap[y][x] >= 0 && tilemap[y][x] < preloadedBlocks.Count)
				{
					Spatial block = preloadedBlocks[tilemap[y][x]].Instance() as Spatial;
					block.Translation = new Vector3(x, 0, y);
					AddChild(block);
				}
				printLn += tilemap[y][x];
				if (tilemap[y][x].ToString().Length == 1) printLn += " ";
				printLn += ",";
			}
			GD.Print(printLn);
		}
	}
	public void Procedural()
	{
		var startingRoom = new int[5][];
		startingRoom[0] = new int[] { 1, 1, 10, 1, 1 };
		startingRoom[1] = new int[] { 1, 0, 0, 0, 1 };
		startingRoom[2] = new int[] { 10, 0, 0, 0, 10 };
		startingRoom[3] = new int[] { 1, 0, 0, 0, 1 };
		startingRoom[4] = new int[] { 1, 1, 10, 1, 1 };
		PlaceRoom(new Vector2Int(diameter / 2, diameter / 2), startingRoom);
		for (int i = 0; i < iterations; i++)
		{
			Iterate();
			//GD.Print("Iteration " + i);
		}
		// Replacing hallways
		for (int y = 0; y < diameter; y++)
			for (int x = 0; x < diameter; x++)
				if (tilemap[y][x] == -2)
					tilemap[y][x] = GetGroundTile(new Vector2Int(x, y));


	}
	public void Iterate()
	{
		for (int y = 0; y < diameter; y++)
			for (int x = 0; x < diameter; x++)
				if (tilemap[y][x] == 10)
				{
					var direction = new Vector2Int(Vector2.Zero);
					if (x + 1 >= diameter || tilemap[y][x + 1] == -1) direction = new Vector2Int(Vector2.Right);
					else if (x - 1 < 0 || tilemap[y][x - 1] == -1) direction = new Vector2Int(Vector2.Left);
					else if (y + 1 >= diameter || tilemap[y + 1][x] == -1) direction = new Vector2Int(Vector2.Up);
					else if (y - 1 < 0 || tilemap[y - 1][x] == -1) direction = new Vector2Int(Vector2.Down);
					TryCreateHall(new Vector2Int(x, y), direction.vector.Angle() * (180 / Mathf.Pi), tries);
				}
	}
	public bool IsRoomOverlapping(Vector2Int coords, int[][] room)
	{
		for (int y = 0; y < diameter; y++)
		{
			for (int x = 0; x < diameter; x++)
			{
				if (room[y][x] != -1)
				{
					int m_y = y + coords.y;
					int m_x = x + coords.x;
					for (int a = -minRoomDistance; a < minRoomDistance + 1; a++)
					{
						for (int b = -minRoomDistance; b < minRoomDistance + 1; b++)
						{
							if (m_y + b < 0 || m_y + b >= diameter || m_x + a < 0 || m_x + a >= diameter)
								return true;
							else if (tilemap[m_y + b][m_x + a] == 1)
								return true;
						}
					}
				}
			}
		}
		return false;
	}
	public bool IsAreaEmpty(Vector2Int coords, int[][] room)
	{
		if (Does2DArrayInclude(tilemap, coords) && Does2DArrayInclude(tilemap, coords + new Vector2Int(room.Length - 1, room.Length - 1)))
		{
			for (int y = 0; y < room.Length; y++)
				for (int x = 0; x < room.Length; x++)
					if (tilemap[y + coords.y][x + coords.x] != -1)
						return false;
		}
		else
		{
			return false;
		}
		return true;
	}
	public void PlaceRoom(Vector2Int coords, int[][] room) {
		for (int y = 0; y < room.Length; y++)
			for (int x = 0; x < room.Length; x++)
				tilemap[y + coords.y][x + coords.x] = room[y][x];
	}
	public void TryCreateHall(Vector2Int coords, float directionAngle, int tries)
	{
		//GD.Print("Creating Hall with " + tries + " tries left");
		int[][] tilemapCopy = tilemap.Clone() as int[][];
		if (tries != 0)
		{
			var currentCoords = coords;
			var currentDir = directionAngle;
			var currentDirInRadians = currentDir * (Mathf.Pi / 180);
			var hallwayTurns = random.Next(minHallwayTurns, maxHallwayTurns + 1);
			tilemapCopy[currentCoords.y][currentCoords.x] = GetGroundTile(currentCoords);
			for (int t = 0; t < hallwayTurns; t++)
			{
				var segmentLength = random.Next(minHallwaySegmentLength, maxHallwaySegmentLength + 1);
				for (int s = 0; s < segmentLength; s++)
				{
					currentDirInRadians = currentDir * (Mathf.Pi / 180);
					currentCoords += new Vector2Int(Mathf.Cos(currentDirInRadians), Mathf.Sin(currentDirInRadians));
					if (Does2DArrayInclude(tilemapCopy, currentCoords))
					{
						int tile = tilemapCopy[currentCoords.y][currentCoords.x];
						if (tile == -1 || tile == -2)
							tilemapCopy[currentCoords.y][currentCoords.x] = -2;
						else
						{
							TryCreateHall(coords, directionAngle, tries - 1);
							return;
						}
					} else
					{
						TryCreateHall(coords, directionAngle, tries - 1);
						return;
					}
				}
				currentDir += random.Next(2) == 0 ? 90 : -90;
			}
			currentDirInRadians = currentDir * (Mathf.Pi / 180);
			var currentDirVect = new Vector2Int(Mathf.Cos(currentDirInRadians), Mathf.Sin(currentDirInRadians));
			var roomData = FindOpeningsInRooms(-currentDirVect);
			foreach (var room in roomData)
				foreach (var coord in room.coords)
					if (IsAreaEmpty(currentCoords - coord, rooms[room.roomIndex]))
					{
						tilemap = tilemapCopy;
						PlaceRoom(currentCoords - coord, rooms[room.roomIndex]);
						tilemap[currentCoords.y][currentCoords.x] = GetGroundTile(currentCoords);
						return;
					}
					else
					{
						TryCreateHall(coords, directionAngle, tries - 1);
						return;
					}
						
		}
		else
		{
			tilemap[coords.y][coords.x] = GetGroundTile(coords);
			return;
		}
	}
	public List<Vector2Int> FindOpeningsInRoom(int roomIndex, Vector2Int direction)
	{
		var list = new List<Vector2Int>();
		for (int y = 0; y < diameter; y++)
			for (int x = 0; x < diameter; x++)
				if (rooms[roomIndex][y][x] == 10)
					if (Does2DArrayInclude(rooms[roomIndex], new Vector2Int(x, y) + direction))
						if (rooms[roomIndex][y + direction.y][x + direction.y] < 0)
							list.Add(new Vector2Int(x, y));
					else
						list.Add(new Vector2Int(x, y));
		return list;
	}
	public List<RoomResult> FindOpeningsInRooms(Vector2Int direction)
	{
		var list = new List<RoomResult>();
		for (int i = 0; i < list.Count; i++)
		{
			var result = new RoomResult();
			result.roomIndex = i;
			result.coords = FindOpeningsInRoom(i, direction);
			if (result.coords.Count > 0) list.Add(result);
		}
		return list;
	}
	public bool Does2DArrayInclude<T>(T[][] array2D, Vector2Int coords)
	{
		return 0 <= coords.x && coords.x < array2D.Length && 0 <= coords.y && coords.y < array2D.Length;
	}
	public int GetGroundTile(Vector2Int coords)
	{
		return 0;
	}
	public int GetWallTile(Vector2Int coords)
	{
		return 1;
	}
}
