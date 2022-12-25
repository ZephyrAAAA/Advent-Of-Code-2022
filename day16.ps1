$file = Get-Content -Path .\day16.txt
$valve = @{}
$valvep = @{}
$max=30
$global:output=0
foreach ($line in $file) {
    $list=$line.Replace("Valve", "").Replace(" ", "").Replace("hasflowrate", "").Replace("tunnelleadstovalve", "").Replace("tunnelsleadtovalves", "").Split("=").Split(";")
    $valve.Add($list[0],$list[2].Split(","))
    $valvep.Add($list[0],$list[1])
}
foreach ($v in $valve) {
    if ($valvep[$v] -eq 0) {
        if ($valve[$v].Count -eq 1) {
            $valve.Remove($v)
        } else {
            foreach ($n in $valve[$to]) {
                if ($valve[$n].Count -gt 1) {
                    $valve.Remove($v)
                }
            }
        }
    }
}
function findpath {
    param ( [string] $to, [int] $count, [int] $dist, [int] $tick, [string] $done, [string] $last )
    $altered=0
	$dist+=$tick
	$count++
	if ($count -ge $max) {
		#Write-Output "complete: ${done}: $dist"
        if ($dist -gt $global:output) { $global:output=$dist;$global:output2=$done }
		return
	}
	foreach ($target in $valve[$to]) {
        if ($target -ne $last) {
            $altered=1
		    findpath -to $target -count $count -dist $dist -tick $tick -done $done -last $to
        }
	}
	if ($valvep[$to] -gt 0 -and -not $done.Contains($to)) {
		$dist+=$tick
		$count++
		$tick+=$valvep[$to]
		$done="$done,$to$count"
	    if ($count -ge $max) {
		    #Write-Output "complete: ${done}: $dist"
            if ($dist -gt $output) {$output=$dist;$global:output2=$done}
		    return
	    }
		foreach ($target in $valve[$to]) {
            $altered=1
            findpath -to $target -count $count -dist $dist -tick $tick -done $done -last $to
		}
	}
    if ($altered -eq 0) {
        $dist+=$tick*($max-$count)
		#Write-Output "complete: ${done}: $dist"
        if ($dist -gt $global:output) { $global:output=$dist;$global:output2=$done }
		return
    }
}
findpath -to AA -count -1 -dist 0 -tick 0 -done "" -last AA
write-output $global:output $global:output2