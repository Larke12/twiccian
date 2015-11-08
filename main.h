// This file is part of Twiccian.
// 
// Twiccian is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Twiccian is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with Twiccian.  If not, see <http://www.gnu.org/licenses/>.

#ifndef MPVRENDERER_H_
#define MPVRENDERER_H_

#include <QtQuick/QQuickFramebufferObject>

#include <mpv/client.h>
#include <mpv/opengl_cb.h>
#include <mpv/qthelper.hpp>
#include <string.h>

// Wraps the opengl-cb mpv instance in a C++ option
class MpvRenderer;

class MpvObject : public QQuickFramebufferObject
{
	Q_OBJECT

	mpv::qt::Handle mpv;
	mpv_opengl_cb_context *mpv_gl;

	friend class MpvRenderer;

public:
	MpvObject(QQuickItem * parent = 0);
	virtual ~MpvObject();
	virtual Renderer *createRenderer() const;
public slots:
	void command(const QVariant& params);
    void setProperty(const QString& name, const QVariant& value);
signals:
	void onUpdate();
private slots:
	void doUpdate();
private:
	static void on_update(void *ctx);
};



#endif
