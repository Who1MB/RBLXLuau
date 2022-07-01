-- grab script
-- Author: Heath Haskins on YouTube
-- https://www.youtube.com/watch?v=yBqEbvbT8_w
-- Modified By: Who1MB
local CAS = game:GetService("ContextActionService")
local UIS = game:GetService('UserInputService')

local GrabObject = nil
local GrabStart = false
local Dragger = nil

local player = game.Players.LocalPlayer
local character = player.Character
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera


function Grab(actionName, UserInputState, InputObject)
	if actionName == "Grab" then
		if UserInputState == Enum.UserInputState.Begin then
			-- start grab
			local Magnitude = (mouse.Hit.Position - character.Head.CFrame.Position).magnitude
			if Magnitude < 10 then

				if mouse.Target then

					GrabObject = mouse.Target
					GrabStart = true

					local DragBall = createDragBall()
					DragBall.CFrame = mouse.Hit
					Dragger = DragBall

					mouse.TargetFilter = GrabObject

					local DragBallWeld = weldBetween(DragBall,GrabObject)
					addMover(DragBall)

					while Dragger do
						--Create a ray from the users head to the mouse.
						local cf = CFrame.new(character.Head.Position, mouse.Hit.Position)
						Dragger.Mover.Position = (cf + (cf.LookVector * 10)).Position
						Dragger.RotMover.CFrame = camera.CFrame * CFrame.Angles(Dragger.RotOffset.Value.X,Dragger.RotOffset.Value.Y, Dragger.RotOffset.Value.Z)
						wait()
					end
					mouse.TargetFilter = nil
				end
			end
		elseif UserInputState == Enum.UserInputState.End then
			-- stop grab

			GrabObject = nil
			GrabStart = false
			if Dragger then
				Dragger:Destroy()
				Dragger = nil
			end
		end
	end	
end


function weldBetween(a, b)
	local weld = Instance.new("ManualWeld", a)
	weld.C0 = a.CFrame:inverse() * b.CFrame
	weld.Part0 = a
	weld.Part1 = b
	return weld
end


function addMover(part)
	local newMover = Instance.new("BodyPosition")
	newMover.Parent = part
	newMover.MaxForce = Vector3.new(40000,40000,40000)
	newMover.P = 40000
	newMover.D = 1000
	newMover.Position = part.Position
	newMover.Name = "Mover"

	local newRot = Instance.new("BodyGyro")
	newRot.Parent = part
	newRot.MaxTorque = Vector3.new(3000,3000,3000)
	newRot.P = 3000
	newRot.D = 500
	newRot.CFrame = game.Workspace.CurrentCamera.CFrame
	newRot.Name = "RotMover"

	local RotOffset = Instance.new("Vector3Value")
	RotOffset.Name = "RotOffset"
	RotOffset.Parent = part
end


function createDragBall()
	local DragBall = Instance.new("Part")
	DragBall.BrickColor = BrickColor.new("Electric blue")
	DragBall.Material = Enum.Material.Wood
	DragBall.Size = Vector3.new(.2,.2,.2)
	DragBall.Shape = "Ball"
	DragBall.Name = "DragBall"
	DragBall.Parent = workspace
	return DragBall
end

-- Added Code for rotation
local keyE = Enum.KeyCode.E
local keyR = Enum.KeyCode.R
local keyT = Enum.KeyCode.T


function rotate(actionName, UserInputState, InputObject)
	if Dragger then
		if actionName == "RotY" then
			while UIS:IsKeyDown(keyE) and Dragger do
				Dragger.RotOffset.Value = Dragger.RotOffset.Value + Vector3.new(0,math.pi/90,0)
				wait()
			end
		elseif actionName == "RotX" then
			while UIS:IsKeyDown(keyR) and Dragger do
				Dragger.RotOffset.Value = Dragger.RotOffset.Value + Vector3.new(math.pi/90,0,0)
				wait()
			end
		elseif actionName == "RotZ" then
			while UIS:IsKeyDown(keyT) and Dragger do
				Dragger.RotOffset.Value = Dragger.RotOffset.Value + Vector3.new(0,0,math.pi/90)
				wait()
			end
		end
	end
end

CAS:BindAction("Grab", Grab, false, Enum.UserInputType.MouseButton1)
CAS:BindAction("RotY", rotate, false, keyE)
CAS:BindAction("RotX", rotate, false, keyR)
CAS:BindAction("RotZ", rotate, false, keyT)
