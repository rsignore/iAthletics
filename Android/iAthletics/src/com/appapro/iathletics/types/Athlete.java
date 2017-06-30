package com.appapro.iathletics.types;

public class Athlete implements Comparable<Athlete>
{
	String name;
	/**
	 * @return the name
	 */
	public String getName()
	{
		return name;
	}

	/**
	 * @param name the name to set
	 */
	public void setName(String name)
	{
		this.name = name;
	}

	/**
	 * @return the number
	 */
	public String getNumber()
	{
		return number;
	}

	/**
	 * @param number the number to set
	 */
	public void setNumber(String number)
	{
		this.number = number;
	}

	/**
	 * @return the grade
	 */
	public String getGrade()
	{
		return grade;
	}

	/**
	 * @param grade the grade to set
	 */
	public void setGrade(String grade)
	{
		this.grade = grade;
	}

	/**
	 * @return the height
	 */
	public String getHeight()
	{
		return height;
	}

	/**
	 * @param height the height to set
	 */
	public void setHeight(String height)
	{
		this.height = height;
	}

	/**
	 * @return the weight
	 */
	public String getWeight()
	{
		return weight;
	}

	/**
	 * @param weight the weight to set
	 */
	public void setWeight(String weight)
	{
		this.weight = weight;
	}

	/**
	 * @return the positions
	 */
	public String getPositions()
	{
		return positions;
	}

	/**
	 * @param positions the positions to set
	 */
	public void setPositions(String positions)
	{
		this.positions = positions;
	}

	String number;
	String grade;
	String height;
	String weight;
	String positions;
	
	public int compareTo(Athlete another)
	{
		int retVal = 0;
		
		retVal = this.number.compareTo(another.number);
		
		if(retVal == 0)
		{
			retVal = this.name.compareTo(another.name);
		}
		
		return retVal;
	}	

}
