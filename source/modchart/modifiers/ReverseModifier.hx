package modchart.modifiers;
import ui.*;
import modchart.*;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
using StringTools;
import math.*;

class ReverseModifier extends Modifier {

  public function getReversePercent(dir:Int, player:Int, scrolling=false){
    var suffix = '';
    lime.app.Application.current.window.alert('start', "a");
    if(scrolling==true)suffix='Scroll';
    lime.app.Application.current.window.alert('scroll shit?', "a");
    var receptors = modMgr.receptors[player];
    var kNum = receptors.length;
    var percent:Float = 0;
    lime.app.Application.current.window.alert('starting count', "a");
    if(dir>=kNum/2)
      percent += getSubmodPercent("split" + suffix,player);
    lime.app.Application.current.window.alert('first done', "a");
    if((dir%2)==1)
      percent += getSubmodPercent("alternate" + suffix,player);
    lime.app.Application.current.window.alert('second done', "a");
    var first = kNum/4;
    var last = kNum-1-first;

    if(dir>=first && dir<=last){
      percent += getSubmodPercent("cross" + suffix,player);
    }
    lime.app.Application.current.window.alert('third done', "a");
    if(suffix==''){
      percent += getPercent(player) + getSubmodPercent("reverse" + Std.string(dir),player);
    }else{
      percent += getSubmodPercent("reverse" + suffix,player);
    }
    lime.app.Application.current.window.alert('fourth done', "a");
    if(getSubmodPercent("unboundedReverse",player)==0){
      percent %=2;
      if(percent>1)percent=2-percent;
    }



    lime.app.Application.current.window.alert('fifth done', "a");
    if(modMgr.state.currentOptions.downScroll)
      percent = 1-percent;
    lime.app.Application.current.window.alert('return?', "a");
    return percent;
  }

  public function getScrollReversePerc(dir:Int, player:Int){
    return getReversePercent(dir,player);
  }

  override function getPath(visualDiff:Float, pos:Vector3, data:Int, player:Int, timeDiff:Float){
    var perc = getReversePercent(data,player);
    var shift = CoolUtil.scale(perc,0,1,modMgr.state.upscrollOffset,modMgr.state.downscrollOffset);
    var mult = CoolUtil.scale(perc,0,1,1,-1);
    shift = CoolUtil.scale(getSubmodPercent("centered",player),0,1,shift,modMgr.state.center.y - 56);

    pos.y = shift + (visualDiff * mult);

    return pos;
  }

  override function updateNote(note:Note, player:Int, pos:Vector3, scale:FlxPoint){
    /*var perc = getScrollReversePerc(note.noteData,note.mustPress==true?0:1);
    if(perc>.5 && note.isSustainNote){
      note.flipY=true;
    }else{
      note.flipY=false;
    }*/
  }

  override function getSubmods(){
    var subMods:Array<String> = ["cross", "split", "alternate", "reverseScroll", "crossScroll", "splitScroll", "alternateScroll", "centered", "unboundedReverse"];

    var receptors = modMgr.receptors[0];
    var kNum = receptors.length;
    for(recep in receptors){
      subMods.push('reverse${recep.direction}');
    }
    return subMods;
  }
}
