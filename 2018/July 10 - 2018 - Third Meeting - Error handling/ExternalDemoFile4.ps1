param
(
	[Parameter(ParameterSetName = 'Path1')]
	[switch]$Path1,
	[Parameter(ParameterSetName = 'Path2')]
	[switch]$Path2,
	[Parameter(ParameterSetName = 'Path3')]
	[switch]$Path3
)
if ($path1)
{
	exit 123
}
if ($path2)
{
	exit 234
}
if ($path3)
{
	exit 0
}

