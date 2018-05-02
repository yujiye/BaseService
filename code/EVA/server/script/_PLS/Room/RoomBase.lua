local RoomBase = class("RoomBase")

-- 构造函数;
function RoomBase:ctor()

    self.RoomID                 = RoomMgr:GenerateRoomID();
    self.PrvRoomID              = 0;
    
    
    self.SeatPlayers            = {};
    self.ViewPlayers            = {};

    self._TimerHandle           = 0;
    self._TimerTick             = 1000;
    print("RoomBase:ctor");
end

function RoomBase:Init( room_type, update_tick )
    
    self.RoomType               = room_type;
    
    if update_tick~=nil then
        self._TimerTick = update_tick;
    end
    
    local ROOM_CFG = StaticTableMgr:GetRoomConfigXml(room_type);
    
    if ROOM_CFG~=nil then
        for i=1,ROOM_CFG.room_max do
            table.insert(self.SeatPlayers, 0);
        end
        
        self._TimerHandle = TimerMgr:AddTimer(self._TimerTick, self, self.TickUpdate);
    end
    
    PrintTable(self.SeatPlayers);
 
end

function RoomBase:TickUpdate()


    print("RoomBase:TickUpdate");

    self._TimerHandle = TimerMgr:AddTimer(self._TimerTick, self, self.TickUpdate);
end


-- 玩家加入房间
function RoomBase:BaseJoinRoom( player )


    player.RoomID   = self.RoomID;

    self:__AddRoomPlayer(player.UID);
    
end

-- 玩家离开房间
function RoomBase:BaseLeaveRoom( uid, is_broadcast, except_id )
    
    local msg_int = { value = uid };
    
	if is_broadcast then
        self:BroadcastMsg( "LR", "PB.MsgInt", msg_int, except_id );
    else
        local player = PlayerMgr:GetPlayer(uid);
        if player~=nil then
            BaseService:SendToClient( player, "LR", "PB.MsgInt", msg_int )
        end
    end
    
    -- 离开房间删除数据
    self:LeaveRoomRemoveData(uid);
end

function RoomBase:LeaveRoomRemoveData( uid )
    

    self:__RemoveRoomPlayer(uid);

    local player = PlayerMgr:GetPlayer(uid);
    
    if player~=nil then
        player.RoomID = 0;
    end
    
end

function RoomBase:IsRoomPlayer( uid )
    for _,v in pairs(self.SeatPlayers) do
        if v==uid then
            return true;
        end
    end
    return false;
end

function RoomBase:GetRoomPlayer( uid )
    for _,v in pairs(self.SeatPlayers) do
        if v==uid then
            return PlayerMgr:GetPlayer(uid);
        end
    end
    return nil;
end

function RoomBase:__GetPlayerSeatIdx( uid )
    for k,v in pairs(self.SeatPlayers) do
        if v==uid then
            return k;
        end
    end
    return 0;
end

function RoomBase:GetRoomPlayerNum()
    local count = 0;
    for _,v in pairs(self.SeatPlayers) do
        if v~=0 then
            count = count + 1;
        end
    end
    return count;
end

function RoomBase:__AddRoomPlayer( uid )
    
    local seat_idx = self:__GetPlayerSeatIdx(uid);
    
    if seat_idx==0 then
        
        for k,v in pairs(self.SeatPlayers) do
            if v==0 then
                self.SeatPlayers[k] = uid;
                seat_idx = k; 
            end
        end
    end
    
    return seat_idx;
end

function RoomBase:__RemoveRoomPlayer( uid )
    
    for k,v in pairs(self.SeatPlayers) do
        if v==uid then
            self.SeatPlayers[k] = 0;
        end
    end

end

function RoomBase:IsFull()
    
    local ROOM_CFG = StaticTableMgr:GetRoomConfigXml(self.RoomType);
    
    if ROOM_CFG~=nil then

        if self:GetRoomPlayerNum()<ROOM_CFG.room_max then
            return false;
        end
    end
    
    return true;
end


--释放函数
function RoomBase:BaseRelease()
    TimerMgr:RemoveTimer(self._TimerHandle);
end


--  广播消息给房间内桌上所有玩家  如有except_id，那么广播给除except_id的其它玩家。
function RoomBase:BroadcastMsg( msg_name, proto_name, proto_stru, except_id )
    
    for _,v in pairs(self.SeatPlayers) do
        if v~=0 then
            if except_id~=v then
                local player = PlayerMgr:GetPlayer(v);
                
                if player~=nil then
                    BaseService:SendToClient( player, msg_name, proto_name, proto_stru )
                end
            end
        end
    end
    
end     
  
--  广播消息给房间内观战所有玩家  如有except_id，那么广播给除except_id的其它玩家。
function RoomBase:BroadcastViewer( msg_name, msg_stru, except_id )
    
    
    
end   

      

function RoomBase:__GetViewPlayerNum()
    return #self.ViewPlayers;
end

function RoomBase:__IsViewPlayer( playerid )
    if self.ViewPlayers[playerid]~=nil then
        return true;
    end
    return false;
end

return RoomBase;
