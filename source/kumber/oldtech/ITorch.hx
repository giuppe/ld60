package kumber.oldtech;

import flixel.util.FlxColor;

interface ITorch
{
    public var x(default,set):Float;
    public var y(default, set):Float;
    public var intensity:Float;
    public var lightColor:FlxColor;
    public var isLed(default, null):Bool;
}