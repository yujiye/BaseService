local RoomDdz = class("RoomDdz",RoomBase)

DdzFSM              = require("Games/PokerDdz/DdzFSM")
DdzPlayerInfo       = require("Games/PokerDdz/DdzPlayerInfo")

-- 构造函数;
function RoomDdz:ctor()

    self.super:ctor();
    print("RoomDdz:ctor");

    self.Fsm                    = DdzFSM:new();
    self.RoomPlayerData         = {};
    
end

-- 玩家加入房间
function RoomDdz:JoinRoom( player )


    local ddz_player = DdzPlayerInfo:new();

    ddz_player:SetState( "PB.TDDZPlayerState", "STATE_DDZ_NEWROLE" );
    
    self.RoomPlayerData[player.UID] = ddz_player;
    
    self:BaseJoinRoom(player);
    
    self:BroadcastGameInfo();
end

-- 玩家离开房间
function RoomDdz:LeaveRoom( uid )
    
	
    
end


function RoomDdz:TickUpdate()

    print("RoomDdz:TickUpdate");



    self._TimerHandle = TimerMgr:AddTimer(self._TimerTick, self, self.TickUpdate);
end


function RoomDdz:BroadcastGameInfo( )
    
    local msg_gameinfo = {};

    for k,v in pairs(self.SeatPlayers) do
        if v~=0 then
            self:SendGameInfo( v, "", msg_gameinfo );
        end
    end


end

function RoomDdz:SendGameInfo( uid, msg_name, msg_ddz_room )
    
    
    msg_ddz_room.room_id = self.PrvRoomID;
    
    self:__FillRoomInfoMsg(msg_ddz_room, uid);


end

function RoomDdz:__FillRoomInfoMsg( msg_ddz_room, current_uid )
    
    
    msg_ddz_room.room_id = self.PrvRoomID;


end


function RoomDdz:__FillPlayerBaseInfoMsg( uid, msg_ddz_room, current_uid )
    
    local player = PlayerMgr:GetPlayer(uid);
    
    if player~=nil then
    
    
    end
    
    



    
    
    
end

function RoomDdz:__FillPlayerCardMsg( uid, msg_ddz_player, current_uid )
    
    local player = PlayerMgr:GetPlayer(uid);
    
    if player~=nil then
    
    
    end
    



    
    
end


--释放函数
function RoomDdz:Release()
    
    self:BaseRelease();
end


return RoomDdz;
