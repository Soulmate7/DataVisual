from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import pymysql

app=Flask(__name__)

app.config['SECRET_KEY']='z1012194891'
app.config['SQLALCHEMY_DATABASE_URI']='mysql+pymysql://root:z1012194891@127.0.0.1:3306/DataVisual'
app.config['SQLALCHEMY_COMMIT_ON_TEARDOWN']=True
db=SQLAlchemy(app)

class Role(db.Model):
    __tablename__='roles'
    id=db.Column(db.Integer,primary_key=True)
    name=db.Column(db.String(64),unique=True)
    users=db.relationship('User',backref='role',lazy='dynamic')

    def __repr(self):
        return '<Role %r>' %self.name
class User(db.Model):
    __tablename__='users'
    id=db.Column(db.Integer,primary_key=True)
    username=db.Column(db.String(64),unique=True,index=True)
    role_id=db.Column(db.Integer,db.ForeignKey('roles.id'))

    def __repr__(self):
        return '<User %r>'%self.username

if __name__=='__main__':
    # 创建表
    # db.drop_all()
    # db.create_all()
    # 插入数据
    # admin_role=Role(name='Admin')
    # user_role=Role(name='User')
    # user_cuc=User(username='cuc',role=admin_role)
    # user_dviz=User(username='dviz',role=user_role)
    # db.session.add_all([admin_role,user_role,user_cuc,user_dviz])
    # db.session.commit()
    # Select
    print(Role.query.all())
    print(User.query.all())
    #delete :select * from users where username='dviz'
    User.query.filter_by(username='dviz').delete()
    print(User.query.all())
    app.run()