using Godot;
public class Vector2Int
{
	public int x;
	public int y;
	public Vector2 vector
	{
		get
		{
			return new Vector2(x, y);
		}
	}
	public Vector2Int(int _x, int _y)
	{
		x = _x;
		y = _y;
	}
	public Vector2Int(Vector2 _vector2)
	{
		x = (int)Mathf.Round(_vector2.x);
		y = (int)Mathf.Round(_vector2.y);
	}
	public Vector2Int(float _x, float _y)
	{
		x = (int)Mathf.Round(_x);
		y = (int)Mathf.Round(_y);
	}
	public static Vector2Int operator +(Vector2Int a, Vector2Int b)
		=> new Vector2Int(a.x + b.x, a.y + b.y);
	public static Vector2Int operator -(Vector2Int a, Vector2Int b)
		=> new Vector2Int(a.x - b.x, a.y - b.y);
	public static Vector2Int operator -(Vector2Int a)
		=> new Vector2Int(-a.x, -a.y);
	public static Vector2Int operator *(Vector2Int a, int b)
		=> new Vector2Int(a.x * b, a.y * b);
}

